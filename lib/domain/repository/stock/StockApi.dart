import '../../../data/ProductEntity.dart';
import '../../../data/alphavantage/quote/AVQuoteModel.dart';

abstract class StockApi {

  Future<List<ProductEntity>?> searchTicker(String text);
  Future<AVQuoteModel?> getLastPriceBySymbol(String symbol);
}