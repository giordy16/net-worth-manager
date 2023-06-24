import 'package:intl/intl.dart';

import 'ProductEntity.dart';
import 'TransactionEntity.dart';

class MarketPosition {
  final ProductEntity product;
  final List<TransactionEntity> transactionsList;

  MarketPosition(this.product, this.transactionsList);

  double getCurrentValue() {
    return getTotQt() * product.lastPriceOnMainCurrency;
  }

  double getTotQt() {
    double qt = 0;
    transactionsList.forEach((element) {
      qt += element.qt;
    });
    return qt;
  }

  double getAvgPrice() {
    if (transactionsList.isEmpty) return 0;

    double num = 0;
    double div = 0;

    transactionsList.forEach((element) {
      num += (element.price * element.qt);
      div += element.qt;
    });
    return num / div;
  }

  double getTotalCost() {
    double cost = 0;
    transactionsList.forEach((element) {
      cost += (element.price * element.qt);
    });
    return cost;
  }

  double getDelta() {
    return (product.lastPriceOnMainCurrency - getAvgPrice()) * getTotQt();
  }

  double getDeltaPerc() {
    return getDelta() / getTotalCost() * 100;
  }
}
