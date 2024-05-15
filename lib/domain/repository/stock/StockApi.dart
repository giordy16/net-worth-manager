import '../../../models/obox/market_info_obox.dart';

abstract class StockApi {

  Future<List<MarketInfo>> searchTicker(String text);
  Future<double?> getLastPriceBySymbol(String symbol);
}