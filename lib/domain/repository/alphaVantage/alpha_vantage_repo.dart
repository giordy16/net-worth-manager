import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/network/av_quote_model.dart';
import 'package:net_worth_manager/domain/repository/stock/StockApi.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/main_currency_forex_change.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../models/network/av_ticker_search.dart';
import '../../../models/obox/market_info_obox.dart';
import '../../../objectbox.g.dart';
import '../../../utils/Constants.dart';

class AlphaVantageRepImp implements StockApi {
  final _client = Dio(BaseOptions(
      baseUrl: Constants.ALPHA_VANTAGE_BASE_URL,
      connectTimeout: Duration(seconds: 10)))
    ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      print("= DioRequest ===================================================");
      print(options.uri);
      print("Headers: ${options.headers}");
      print("================================================================");
      return handler.next(options);
    }, onResponse: (response, handler) {
      print("= DioResponse ==================================================");
      print("Code: ${response.statusCode}");
      print("Data: ${response.data}");
      print("================================================================");
      return handler.next(response);
    }, onError: (DioException e, handler) {
      print("= DioException =================================================");
      print(e);
      print("================================================================");
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

    // first look on db
    double? price = GetIt.instance<Store>()
        .box<MarketInfo>()
        .query(MarketInfo_.symbol.equals(symbol) &
            MarketInfo_.dateLastPriceFetch
                .equalsDate(DateTime.now().keepOnlyYMD()))
        .build()
        .findFirst()
        ?.value;

    if (price != null) return price;

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
      List<AssetHistoryTimeValue> historyDB =
          marketInfo.getHistoryChronologicalOrder();
      var latestHistoryValue = historyDB.lastOrNull;
      var oldestHistoryValue = historyDB.firstOrNull;
      if ((latestHistoryValue != null &&
              df.format(latestHistoryValue.date) == df.format(yesterday)) &&
          (oldestHistoryValue != null &&
              df.format(oldestHistoryValue.date) == df.format(startDate))) {
        // db contains the 2 extremities, so it's up to date
        return marketInfo.historyValue
            .where((element) => element.date
                .isAfter(startDate.subtract(const Duration(days: 1))))
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
      var daysToLoop = yesterday.difference(startDate).inDays + 1;

      Map<String, dynamic> response =
          (await _client.get("query", queryParameters: queryData)).data;

      if (response.containsKey("Time Series (Daily)")) {
        Map<String, dynamic> json = response["Time Series (Daily)"];
        for (var i = 0; i <= daysToLoop; i++) {
          DateTime day = startDate.add(Duration(days: i));

          // for some reason the hour after i = 135 is 01 and not 00
          if (day.hour == 1) {
            day = day.subtract(const Duration(hours: 1));
          }

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

  @override
  Future<void> fetchForexChange(
    String originCurrencyName,
  ) async {
    String mainCurrencySymbol = objectbox.store
        .box<Settings>()
        .getAll()
        .first
        .defaultCurrency
        .target!
        .name;

    final forexBox = objectbox.store.box<CurrencyForexChange>();
    final df = DateFormat("yyyy-MM-dd");

    final forexChangeForCurrency = forexBox
        .query(CurrencyForexChange_.name
            .equals("$originCurrencyName$mainCurrencySymbol"))
        .order(CurrencyForexChange_.date, flags: Order.descending)
        .build()
        .find();

    CurrencyForexChange? lastChange = forexChangeForCurrency.firstOrNull;

    if (lastChange != null && lastChange.date.day == DateTime.now().day) {
      // db is up to date return them
      return;
    }

    Map<String, String> queryData = {
      "function": "FX_DAILY",
      "from_symbol": originCurrencyName,
      "to_symbol": mainCurrencySymbol,
      "apikey": Constants.ALPHA_VANTAGE_KEY
    };

    if (lastChange == null ||
        lastChange.date.difference(DateTime.now()).abs().inDays > 80) {
      // for that combo do currency there are no values or they are not updates since 80 days
      // call full api
      queryData.addAll({"outputsize": "full"});
    }

    try {
      var response = await _client.get("query", queryParameters: queryData);

      List<CurrencyForexChange> forexHistory = [];
      if ((response.data as Map<String, dynamic>)
          .containsKey("Time Series FX (Daily)")) {
        Map<String, dynamic> forexHistoryJson =
            response.data["Time Series FX (Daily)"];
        for (var entry in forexHistoryJson.entries.toList()) {
          forexHistory.add(CurrencyForexChange(
              "$originCurrencyName$mainCurrencySymbol",
              df.parse(entry.key),
              double.parse(entry.value["4. close"])));
        }
      }

      // remove the one already in the db
      for (var dbForex in forexChangeForCurrency) {
        forexHistory.removeWhere((element) => element.date == dbForex.date);
      }

      // save to db
      forexBox.putMany(forexHistory);
    } catch (e) {
      print("fetchForexChange error: $e");
      return null;
    }
  }
}
