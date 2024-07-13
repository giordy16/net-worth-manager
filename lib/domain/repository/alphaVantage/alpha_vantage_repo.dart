import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_images.dart';
import 'package:net_worth_manager/domain/repository/stock/stock_api.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/main_currency_forex_change.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../models/network/av/av_ticker_search.dart';
import '../../../models/network/fmp/fmp_split_historical.dart';
import '../../../models/obox/market_info_obox.dart';
import '../../../objectbox.g.dart';
import '../../../ui/scaffold_with_bottom_navigation.dart';
import '../../../utils/Constants.dart';
import '../../../utils/enum/fetch_forex_type.dart';

class AlphaVantageRepImp implements StockApi {
  final BuildContext? context;
  late Dio _client;

  AlphaVantageRepImp({this.context}) {
    _client = Dio(BaseOptions(
        baseUrl: Constants.ALPHA_VANTAGE_BASE_URL,
        connectTimeout: Duration(seconds: 10)))
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        print(
            "= DioRequest ===================================================");
        print(options.uri);
        print("Headers: ${options.headers}");
        print(
            "================================================================");
        return handler.next(options);
      }, onResponse: (response, handler) {
        print(
            "= DioResponse ==================================================");
        print("Code: ${response.statusCode}");
        print("Data: ${response.data}");
        print(
            "================================================================");
        return handler.next(response);
      }, onError: (DioException e, handler) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout) {
          // no internet
          if (context != null) {
            showOkOnlyBottomSheet(
              context!,
              "It seems that you are offline.\nTo have updated values, please turn on mobile data or Wi-Fi and reopen the app.",
              imageAboveMessage: AppImages.noConnection,
            );
          } else {
            // the only case when context == null is during the call on the splash,
            // where there is no context. For this reason, I set to true a flag on the
            // first app route
            ScaffoldWithBottomNavigation.noInternetConnection = true;
          }
        }

        print(
            "= DioException =================================================");
        print(e);
        print(
            "================================================================");
        return handler.next(e);
      }));
  }

  @override
  Future<List<MarketInfo>> searchAssetByNameTicker(String text) async {
    try {
      dynamic queryData = {
        "function": "SYMBOL_SEARCH",
        "keywords": Uri.encodeFull(text),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      var response = await _client.get("query", queryParameters: queryData);

      return AVTickerSearch.fromJson(response.data)
          .bestMatches
          .map((e) => MarketInfo(
                symbol: e.symbol,
                name: e.name,
                type: e.type,
                currency: e.currency,
                region: e.region,
              ))
          .toList();
    } catch (e) {
      print("searchTicker error: $e");
      return [];
    }
  }

  @override
  Future<double?> getLastPriceBySymbol(String symbol) async {
    return 0;

    // first look on db
    // double? price = GetIt.instance<Store>()
    //     .box<MarketInfo>()
    //     .query(MarketInfo_.symbol.equals(symbol) &
    //         MarketInfo_.dateLastPriceFetch
    //             .equalsDate(DateTime.now().keepOnlyYMD()))
    //     .build()
    //     .findFirst()
    //     ?.value;
    //
    // if (price != null) return price;
    //
    // try {
    //   dynamic queryData = {
    //     "function": "GLOBAL_QUOTE",
    //     "symbol": Uri.encodeFull(symbol),
    //     "apikey": Constants.ALPHA_VANTAGE_KEY
    //   };
    //
    //   var response = await _client.get("query", queryParameters: queryData);
    //   return AVQuoteList.fromJson(response.data).quote.price;
    // } catch (e) {
    //   print("getLastPriceBySymbol error: $e");
    //   return null;
    // }
  }

  @override
  Future<void> fetchForexChange(
    String originCurrencyName, {
    required FMPFetchType fetchType,
    DateTime? startFetchDate,
  }) async {
    String mainCurrencySymbol = GetIt.I<Store>()
        .box<Settings>()
        .getAll()
        .first
        .defaultCurrency
        .target!
        .name;

    final forexBox = GetIt.I<Store>().box<CurrencyForexChange>();
    final df = DateFormat("yyyy-MM-dd");

    final forexChangeForCurrency = forexBox
        .query(CurrencyForexChange_.name
            .equals("$originCurrencyName$mainCurrencySymbol"))
        .order(CurrencyForexChange_.date, flags: Order.descending)
        .build()
        .find();

    CurrencyForexChange? lastChange = forexChangeForCurrency.firstOrNull;

    if (lastChange != null &&
        lastChange.lastFetchDate == DateTime.now().keepOnlyYMD()) {
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
        lastChange.lastFetchDate.difference(DateTime.now()).abs().inDays > 80) {
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
            double.parse(entry.value["4. close"]),
            DateTime.now().keepOnlyYMD(),
          ));
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

  /// the api will have the latest value as first element, with this structure:
  /// "Time Series (Daily)": {
  ///  "2024-05-29": {
  ///      "1. open": "66.1500",
  ///      "2. high": "66.2400",
  ///      "3. low": "65.3500",
  ///      "4. close": "65.4700",
  ///      "5. volume": "3414908"
  ///  },
  ///  "2024-05-28": {
  ///      ...
  ///  },
  ///  ...
  ///
  ///  so i'll loop starting from today and every step of the loop i'll take
  ///  the object with key == today-i. the loop will end when for DAYS_STOP days in
  ///  a row no value will be found
  @override
  Future<void> fetchPriceHistoryBySymbol(
    MarketInfo marketInfo, {
    required FMPFetchType fetchType,
    DateTime? startFetchDate,
  }) async {
    const int DAYS_STOP = 10;

    // if already fetch today, not fetching anymore
    if (marketInfo.dateLastPriceFetch != null &&
        marketInfo.dateLastPriceFetch!
            .keepOnlyYMD()
            .isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
      return;
    }

    try {
      Map<String, dynamic> queryData = {
        "function": "TIME_SERIES_DAILY",
        "symbol": Uri.encodeFull(marketInfo.symbol),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      if (marketInfo.dateLastPriceFetch == null ||
          DateTime.now()
                  .difference(marketInfo.dateLastPriceFetch!)
                  .abs()
                  .inDays >
              80) {
        queryData.addAll({"outputsize": "full"});
      }

      Map<String, dynamic> response =
          (await _client.get("query", queryParameters: queryData)).data;

      List<AssetHistoryTimeValue> history = [];
      final df = DateFormat("yyyy-MM-dd");

      if (response.containsKey("Time Series (Daily)")) {
        Map<String, dynamic> json = response["Time Series (Daily)"];

        int i = 0;
        int daysWithNoValue = 0;

        while (daysWithNoValue < DAYS_STOP) {
          DateTime day =
              DateTime.now().subtract(Duration(days: i)).keepOnlyYMD();
          String key = df.format(day);
          if (json.containsKey(key)) {
            daysWithNoValue = 0;
            Map<String, dynamic> dayValueJson = json[key];

            history.add(AssetHistoryTimeValue(
              day,
              double.parse(dayValueJson["4. close"]),
              marketInfo.symbol,
            ));
          } else {
            daysWithNoValue++;
          }
          i++;
        }
      }

      final historyBox = GetIt.I<Store>().box<AssetHistoryTimeValue>();
      var dbHistory = historyBox
          .query(AssetHistoryTimeValue_.assetSymbol.equals(marketInfo.symbol))
          .build()
          .find();

      // remove from the data fetched the one already in the db
      dbHistory.forEach((dbElement) {
        history.removeWhere(
            (element) => element.date.isAtSameMomentAs(dbElement.date));
      });

      // save
      historyBox.putMany(history);

      marketInfo.dateLastPriceFetch = DateTime.now().keepOnlyYMD();
      GetIt.I<Store>().box<MarketInfo>().put(marketInfo);
    } catch (e) {
      print("fetchPriceHistoryBySymbol error: $e");
    }
  }

  @override
  Future<List<FmpSplitHistoricalItem>> getSplitHistorical(String symbol) {
    throw UnimplementedError();
  }

  @override
  Future<List<MarketInfo>> searchAssetByIsin(String text) {
    throw UnimplementedError();
  }

}
