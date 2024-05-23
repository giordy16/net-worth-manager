import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/main_currency_forex_change.dart';

import '../../../models/obox/market_info_obox.dart';

abstract class StockApi {
  Future<List<MarketInfo>> searchTicker(String text);

  Future<double?> getLastPriceBySymbol(String symbol);

  Future<List<AssetHistoryTimeValue>?> getPriceHistoryBySymbol(
    MarketInfo marketInfo,
    DateTime? startDate,
  );

  Future<void> fetchForexChange(String originCurrencyName);
}
