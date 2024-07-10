
import '../../../models/network/fmp/fmp_split_historical.dart';
import '../../../models/obox/market_info_obox.dart';
import '../../../utils/enum/fetch_forex_type.dart';

abstract class StockApi {
  Future<List<MarketInfo>> searchTicker(String text);

  Future<double?> getLastPriceBySymbol(String symbol);

  Future<void> fetchForexChange(
    String originCurrencyName, {
    required FMPFetchType fetchType,
    DateTime? startFetchDate,
  });

  Future<void> fetchPriceHistoryBySymbol(
    MarketInfo marketInfo, {
    required FMPFetchType fetchType,
        DateTime? startFetchDate,
  });

  Future<List<FmpSplitHistoricalItem>> getSplitHistorical(String symbol);

}
