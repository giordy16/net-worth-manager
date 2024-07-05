import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/main_currency_forex_change.dart';

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
}
