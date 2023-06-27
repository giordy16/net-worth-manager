import 'package:forex_conversion/forex_conversion.dart';

import 'ProductEntity.dart';
import 'TransactionEntity.dart';

class MarketPosition {
  final ProductEntity product;
  List<TransactionEntity> transactionsList;

  MarketPosition(this.product, this.transactionsList);

  final fx = Forex();

  double getCurrentValueOnUserCurrency() {
    return getTotQt() * product.lastPriceOnUserCurrency;
  }

  double getTotQt() {
    double qt = 0;
    transactionsList.forEach((element) {
      qt += element.qt;
    });
    return qt;
  }

  double getAvgPriceOnAssetCurrency() {
    if (transactionsList.isEmpty) return 0;

    double num = 0;
    double div = 0;

    transactionsList.forEach((element) {
      num += element.getTotalCostOnAssetCurrency();
      div += element.qt;
    });
    return num / div;
  }

  double getTotalCostOnAssetCurrency() {
    double cost = 0;
    transactionsList.forEach((element) {
      cost += element.getTotalCostOnAssetCurrency();
    });
    return cost;
  }

  double getDelta() {
    return (product.lastPrice - getAvgPriceOnAssetCurrency()) * getTotQt();
  }

  Future<double> getAvgPriceOnUserCurrency() async {
    return await fx.getCurrencyConverted(
        sourceCurrency: product.currency,
        destinationCurrency: "EUR", // todo change with main currency
        sourceAmount: getAvgPriceOnAssetCurrency());
  }

  Future<double> getPerformanceOnUserCurrency() async {
    return (product.lastPriceOnUserCurrency -
            await getAvgPriceOnUserCurrency()) *
        getTotQt();
  }

  double getPerformancePerc() {
    return getDelta() / getTotalCostOnAssetCurrency() * 100;
  }

  double getPerformanceOfTransaction(TransactionEntity transaction) {
    return (product.lastPrice - transaction.getPriceOnAssetCurrency()) /
        transaction.getPriceOnAssetCurrency() *
        100;
  }

  void updateTransactionList(List<TransactionEntity> list) {
    transactionsList = list.toList();
  }
}
