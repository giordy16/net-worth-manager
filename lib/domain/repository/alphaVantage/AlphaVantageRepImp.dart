import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/network/av_quote_model.dart';
import 'package:net_worth_manager/domain/repository/stock/StockApi.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';

import '../../../models/network/av_ticker_search.dart';
import '../../../models/obox/market_info_obox.dart';
import '../../../utils/Constants.dart';

class AlphaVantageRepImp implements StockApi {
  final _client = Dio(BaseOptions(baseUrl: Constants.ALPHA_VANTAGE_BASE_URL))
    ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      print("${options.baseUrl}${options.path}/${options.queryParameters}/");
      return handler.next(options);
    }, onResponse: (response, handler) {
      print(response.data);
      return handler.next(response);
    }, onError: (DioException e, handler) {
      print(e);
      return handler.next(e);
    }));

  @override
  Future<List<MarketInfo>> searchTicker(String text) async {
    try {
      dynamic queryData = {
        "function": "SYMBOL_SEARCH",
        "keywords": Uri.encodeFull(text),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      var response = await _client.get("query", queryParameters: queryData);

      return AVTickerSearch.fromJson(response.data)
          .bestMatches
          .map(
              (e) => MarketInfo(e.symbol, e.name, e.type, e.currency, e.region))
          .toList();
    } catch (e) {
      print("searchTicker error: $e");
      return [];
    }
  }

  @override
  Future<double?> getLastPriceBySymbol(String symbol) async {
    try {
      dynamic queryData = {
        "function": "GLOBAL_QUOTE",
        "symbol": Uri.encodeFull(symbol),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      var response = await _client.get("query", queryParameters: queryData);
      return AVQuoteList.fromJson(response.data).quote.price;
    } catch (e) {
      print("getLastPriceBySymbol error: $e");
      return null;
    }
  }

  @override
  Future<List<AssetHistoryTimeValue>?> getPriceHistoryBySymbol(
    MarketInfo marketInfo,
    DateTime? startDate,
  ) async {
    if (startDate == null) return [];

    final df = DateFormat("yyyy-MM-dd");
    final yesterday =
        df.parse(df.format(DateTime.now())).subtract(const Duration(days: 1));

    try {
      // first look on the db
      var lastHistoryValue = marketInfo.historyValue.firstOrNull;
      var firstHistoryValue = marketInfo.historyValue.lastOrNull;
      if ((lastHistoryValue != null &&
              df.format(lastHistoryValue.date) == df.format(yesterday)) &&
          (firstHistoryValue != null &&
              df.format(lastHistoryValue.date) == df.format(startDate))) {
        // db contains the 2 extremities, so it's up to date
        return marketInfo.historyValue
            .where((element) =>
                element.date.isAfter(startDate.subtract(const Duration(days: 1))))
            .toList();
      }

      // db is NOT up to date, fetch history from API
      dynamic queryData = {
        "function": "TIME_SERIES_DAILY",
        "symbol": Uri.encodeFull(marketInfo.symbol),
        "outputsize": "full",
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      List<AssetHistoryTimeValue> history = [];
      var daysToLoop = yesterday.difference(startDate).inDays;

      Map<String, dynamic> response =
          (await _client.get("query", queryParameters: queryData)).data;

      if (response.containsKey("Time Series (Daily)")) {
        Map<String, dynamic> json = response["Time Series (Daily)"];
        for (var i = 0; i <= daysToLoop; i++) {
          DateTime day = startDate.add(Duration(days: i));
          String dayString = df.format(day);
          if (json.containsKey(dayString)) {
            Map<String, dynamic> dayValueJson = json[dayString];
            history.add(AssetHistoryTimeValue(
                day, double.parse(dayValueJson["4. close"])));
          }
        }
      }

      // save to db
      marketInfo.historyValue.clear();
      marketInfo.historyValue.addAll(history);
      objectbox.store.box<MarketInfo>().put(marketInfo);

      return history;
    } catch (e) {
      print("getPriceHistoryBySymbol error: $e");
      return null;
    }
  }
}
