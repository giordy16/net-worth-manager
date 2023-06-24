import 'package:get/get.dart';
import 'package:net_worth_manager/data/MarketPosition.dart';
import 'package:net_worth_manager/domain/repository/alphaVantage/AlphaVantageRep.dart';
import 'package:net_worth_manager/domain/repository/alphaVantage/AlphaVantageRepImp.dart';
import 'package:net_worth_manager/domain/repository/products/ProductRepo.dart';
import 'package:net_worth_manager/domain/repository/products/ProductRepoImpl.dart';
import 'package:net_worth_manager/domain/repository/transaction/TransactionRepoImpl.dart';
import 'package:net_worth_manager/utils/extensions/NumberExtension.dart';

import '../../../data/ProductEntity.dart';
import '../../../data/TransactionEntity.dart';
import '../../../domain/repository/transaction/TransactionRepo.dart';

class InvestmentsController extends GetxController {
  final AlphaVantageRep _avRepo = Get.put(AlphaVantageRepImp());
  final TransactionRepo _transactionRepo = Get.put(TransactionRepoImpl());
  final ProductRepo _productRepo = Get.put(ProductRepoImpl());

  RxList<ProductEntity> tickerSearchResult = <ProductEntity>[].obs;
  RxList<MarketPosition> marketPositionList = <MarketPosition>[].obs;

  Future<void> tickerSearch(String text) async {
    _avRepo
        .searchTicker(text)
        .then((value) => _setSearchList(value ?? []))
        .onError((error, stackTrace) => _setSearchList([]));
  }

  void _setSearchList(List<ProductEntity> list) {
    tickerSearchResult.value = list;
  }

  Future<void> addTransaction(
      TransactionEntity transaction, ProductEntity product) async {
    await _transactionRepo.addTransaction(transaction, product);

    double currentPrice =
        (await _avRepo.getLastPriceBySymbol(product.ticker))?.price ?? 0;
    await product.updateLastPrice(currentPrice);
    await _productRepo.updateProduct(product);
  }

  Future<void> getAllPositions() async {
    List<MarketPosition> marketPosition = [];
    List<ProductEntity>? products = await _productRepo.getProducts();
    if (products != null) {
      await refreshAllPrices(products: products);

      await Future.forEach(products, (product) async {
        List<TransactionEntity>? transactions =
            await _transactionRepo.getTransactionsByProduct(product.ticker);

        if (transactions != null) {
          marketPosition.add(MarketPosition(product, transactions));
        }
      });
    }

    marketPositionList.clear();
    marketPositionList.addAll(marketPosition);
  }

  Future<void> refreshAllPrices({List<ProductEntity>? products}) async {
    List<ProductEntity>? _products = products?.toList();

    _products ??= await _productRepo.getProducts();

    if (_products != null) {
      Future.forEach(_products, (product) async {
        double lastPrice =
            (await _avRepo.getLastPriceBySymbol(product.ticker))?.price ?? 0;
        await product.updateLastPrice(lastPrice);
        await _productRepo.updateProduct(product);
      });
    }
  }

  String getTotalInvestmentsValue() {
    double total = 0;
    marketPositionList.forEach((element) {
      total += element.getCurrentValue();
    });
    return total.formatted();
  }
}
