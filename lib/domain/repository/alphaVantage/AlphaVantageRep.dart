import '../../../data/ProductEntity.dart';
import '../../../data/alphavantage/quote/QuoteModel.dart';

abstract class AlphaVantageRep {

  Future<List<ProductEntity>?> searchTicker(String text);
  Future<QuoteModel?> getLastPriceBySymbol(String symbol);
}