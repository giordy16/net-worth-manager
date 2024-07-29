import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/domain/repository/stock/stock_api.dart';
import 'package:net_worth_manager/models/network/fmp/fmp_forex.dart';
import 'package:net_worth_manager/models/network/fmp/fmp_ticker_search.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../app_images.dart';
import '../../../models/network/fmp/fmp_isin_search.dart';
import '../../../models/network/fmp/fmp_split_historical.dart';
import '../../../models/obox/asset_history_time_value.dart';
import '../../../models/obox/main_currency_forex_change.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../objectbox.g.dart';
import '../../../ui/scaffold_with_bottom_navigation.dart';
import '../../../ui/widgets/modal/bottom_sheet.dart';
import '../../../utils/constants.dart';
import '../../../utils/enum/fetch_forex_type.dart';

class FinancialModelingRepoImpl implements StockApi {
  final BuildContext? context;
  late Dio _client;

  FinancialModelingRepoImpl({this.context}) {
    _client = Dio(BaseOptions(
        baseUrl: Constants.FMP_BASE_URL,
        connectTimeout: const Duration(seconds: 10)))
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
  Future<void> fetchForexChange(
    String originCurrencyName, {
    required FMPFetchType fetchType,
    DateTime? startFetchDate,
  }) async {
    String mainCurrencySymbol =
        GetIt.I<Settings>().defaultCurrency.target!.name;

    final forexBox = GetIt.I<Store>().box<CurrencyForexChange>();
    final df = DateFormat("yyyy-MM-dd HH:mm:ss");
    final dfQuery = DateFormat("yyyy-MM-dd");

    final forexChangeForCurrency = forexBox
        .query(CurrencyForexChange_.name
            .equals("$originCurrencyName$mainCurrencySymbol"))
        .order(CurrencyForexChange_.date)
        .build()
        .find();

    CurrencyForexChange? firstForex = forexChangeForCurrency.firstOrNull;
    CurrencyForexChange? lastForex = forexChangeForCurrency.lastOrNull;

    switch (fetchType) {
      /// in this case, I have to start from the last value until today
      case FMPFetchType.appStart:
        if (NetWorthRepoImpl().getDateFirstNWValue() == null) {
          // no fetch is necessary since nw is empty
          return;
        }

        if (lastForex == null ||
            lastForex.lastFetchDate == DateTime.now().keepOnlyYMD()) {
          // no fetch is necessary since db is up to date
          return;
        }

        DateTime start = lastForex.date.copyWith(day: lastForex.date.day + 1);
        DateTime end = start.copyWith(year: start.year + 5);

        bool limitReached = false;

        while (!limitReached) {
          if (end.isAfter(DateTime.now().keepOnlyYMD()) ||
              end.isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
            limitReached = true;
          }

          try {
            Map<String, String> queryData = {
              "apikey": Constants.FMP_KEY,
              "from": dfQuery.format(start),
              "to": dfQuery.format(end),
            };

            var response = await _client.get(
                "api/v3/historical-chart/1day/$originCurrencyName$mainCurrencySymbol",
                queryParameters: queryData);

            List<CurrencyForexChange> forexHistory =
                (response.data as List<dynamic>)
                    .map((e) => FMPForex.fromJson(e as Map<String, dynamic>))
                    .map((e) => CurrencyForexChange(
                        "$originCurrencyName$mainCurrencySymbol",
                        df.parse(e.date),
                        e.close,
                        DateTime.now().keepOnlyYMD()))
                    .toList();

            // save to db
            forexBox.putMany(forexHistory);
          } catch (e) {
            print("fetchForexChange error: $e");
          }

          start = end.copyWith(day: end.day + 1);
          end = end.copyWith(year: end.year + 5);
        }
        break;

      /// in this case, I have to start from the first value until today
      case FMPFetchType.mainCurrencyChange:
        var firstNWDate = NetWorthRepoImpl().getDateFirstNWValue();

        if (firstNWDate == null) {
          // no fetch is necessary since nw is empty
          return;
        }

        DateTime start = firstNWDate.copyWith(day: firstNWDate.day - 7);
        DateTime end = start.copyWith(year: start.year + 5);

        bool limitReached = false;

        while (!limitReached) {
          if (end.isAfter(DateTime.now().keepOnlyYMD()) ||
              end.isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
            limitReached = true;
          }

          try {
            Map<String, String> queryData = {
              "apikey": Constants.FMP_KEY,
              "from": dfQuery.format(start),
              "to": dfQuery.format(end),
            };

            var response = await _client.get(
                "api/v3/historical-chart/1day/$originCurrencyName$mainCurrencySymbol",
                queryParameters: queryData);

            List<CurrencyForexChange> forexHistory =
                (response.data as List<dynamic>)
                    .map((e) => FMPForex.fromJson(e as Map<String, dynamic>))
                    .map((e) => CurrencyForexChange(
                        "$originCurrencyName$mainCurrencySymbol",
                        df.parse(e.date),
                        e.close,
                        DateTime.now().keepOnlyYMD()))
                    .toList();

            // save to db
            forexBox.putMany(forexHistory);
          } catch (e) {
            print("fetchForexChange error: $e");
          }

          start = end.copyWith(day: end.day + 1);
          end = end.copyWith(year: end.year + 5);
        }
        break;

      /// in this case, I have to start from the date of the new position until today
      case FMPFetchType.addPosition:
        if (firstForex != null &&
            (firstForex.date.isBefore(startFetchDate!) ||
                firstForex.date.isAtSameMomentAs(startFetchDate))) {
          // db is up to date return them
          return;
        }

        DateTime start = startFetchDate!.copyWith(day: startFetchDate.day - 7);
        DateTime end = start.copyWith(year: start.year + 5);

        bool limitReached = false;

        while (!limitReached) {
          if (end.isAfter(DateTime.now().keepOnlyYMD()) ||
              end.isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
            limitReached = true;
          }

          try {
            Map<String, String> queryData = {
              "apikey": Constants.FMP_KEY,
              "from": dfQuery.format(start),
              "to": dfQuery.format(end),
            };

            var response = await _client.get(
                "api/v3/historical-chart/1day/$originCurrencyName$mainCurrencySymbol",
                queryParameters: queryData);

            List<CurrencyForexChange> forexHistory =
                (response.data as List<dynamic>)
                    .map((e) => FMPForex.fromJson(e as Map<String, dynamic>))
                    .map((e) => CurrencyForexChange(
                        "$originCurrencyName$mainCurrencySymbol",
                        df.parse(e.date),
                        e.close,
                        DateTime.now().keepOnlyYMD()))
                    .toList();

            // save to db
            forexBox.putMany(forexHistory);
          } catch (e) {
            print("fetchForexChange error: $e");
          }

          start = end.copyWith(day: end.day + 1);
          end = end.copyWith(year: end.year + 5);
        }
        break;
    }
  }

  @override
  Future<void> fetchPriceHistoryBySymbol(
    MarketInfo marketInfo, {
    required FMPFetchType fetchType,
    DateTime? startFetchDate,
  }) async {
    final historyBox = GetIt.I<Store>().box<AssetHistoryTimeValue>();
    final dfQuery = DateFormat("yyyy-MM-dd");
    final df = DateFormat("yyyy-MM-dd HH:mm:ss");

    switch (fetchType) {
      /// in this case, I have to start from the last value until today
      case FMPFetchType.appStart:
        DateTime? dateLastValue = historyBox
            .query(AssetHistoryTimeValue_.assetSymbol.equals(marketInfo.symbol))
            .order(AssetHistoryTimeValue_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.date;

        if (dateLastValue == null ||
            dateLastValue.isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
          // date null or db up to date
          return;
        }

        DateTime start = dateLastValue.copyWith(day: dateLastValue.day + 1);
        DateTime end = start.copyWith(year: start.year + 5);

        bool limitReached = false;

        while (!limitReached) {
          if (end.isAfter(DateTime.now().keepOnlyYMD()) ||
              end.isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
            limitReached = true;
          }

          try {
            Map<String, String> queryData = {
              "apikey": Constants.FMP_KEY,
              "from": dfQuery.format(start),
              "to": dfQuery.format(end),
            };

            var response = await _client.get(
                "api/v3/historical-chart/1day/${marketInfo.symbol}",
                queryParameters: queryData);

            List<AssetHistoryTimeValue> assetHistory =
                (response.data as List<dynamic>)
                    .map((e) => FMPForex.fromJson(e as Map<String, dynamic>))
                    .map((e) => AssetHistoryTimeValue(
                          df.parse(e.date),
                          e.close,
                          marketInfo.symbol,
                        ))
                    .toList();

            // save to db
            historyBox.putMany(assetHistory);
          } catch (e) {
            print("fetchForexChange error: $e");
          }

          start = end.copyWith(day: end.day + 1);
          end = end.copyWith(year: end.year + 5);
        }

        break;

      /// in this case, I have to start from the date of the new position until today

      case FMPFetchType.addPosition:
        var historicalAssetValues = historyBox
            .query(AssetHistoryTimeValue_.assetSymbol.equals(marketInfo.symbol))
            .order(AssetHistoryTimeValue_.date)
            .build()
            .find();

        DateTime? dateFirstValue = historicalAssetValues.firstOrNull?.date;

        if (dateFirstValue != null &&
            (dateFirstValue.isAtSameMomentAs(startFetchDate!) ||
                dateFirstValue.isBefore(startFetchDate))) {
          // db is updated
          return;
        }

        DateTime start = startFetchDate!.copyWith(day: startFetchDate.day - 7);
        DateTime end = start.copyWith(year: start.year + 5);

        bool limitReached = false;

        while (!limitReached) {
          if (end.isAfter(DateTime.now().keepOnlyYMD()) ||
              end.isAtSameMomentAs(DateTime.now().keepOnlyYMD())) {
            limitReached = true;
          }

          try {
            Map<String, String> queryData = {
              "apikey": Constants.FMP_KEY,
              "from": dfQuery.format(start),
              "to": dfQuery.format(end),
            };

            var response = await _client.get(
                "api/v3/historical-chart/1day/${marketInfo.symbol}",
                queryParameters: queryData);

            List<AssetHistoryTimeValue> assetHistory =
                (response.data as List<dynamic>)
                    .map((e) => FMPForex.fromJson(e as Map<String, dynamic>))
                    .map((e) => AssetHistoryTimeValue(
                          df.parse(e.date),
                          e.close,
                          marketInfo.symbol,
                        ))
                    .toList();

            // save to db
            historyBox.putMany(assetHistory);
          } catch (e) {
            print("fetchForexChange error: $e");
          }

          start = end.copyWith(day: end.day + 1);
          end = end.copyWith(year: end.year + 5);
        }

        break;
      default:
        break;
    }
  }

  @override
  Future<double?> getLastPriceBySymbol(String symbol) async {
    return 0;
  }

  @override
  Future<List<MarketInfo>> searchAssetByNameTicker(String text) async {
    try {
      dynamic queryData = {"query": text, "apikey": Constants.FMP_KEY};

      var response =
          await _client.get("api/v3/search", queryParameters: queryData);

      return (response.data as List<dynamic>)
          .map((e) => FMPTickerSearch.fromJson(e as Map<String, dynamic>))
          .where((e) => e.currency != null)
          .toList()
          .map((e) => MarketInfo(
                symbol: e.symbol,
                name: e.name,
                currency: e.currency!,
                exchangeName: e.stockExchange ?? e.exchangeShortName,
                exchangeNameShort: e.exchangeShortName,
              ))
          .toList();
    } catch (e) {
      print("searchTicker error: $e");
      return [];
    }
  }

  @override
  Future<List<MarketInfo>> searchAssetByIsin(String text) async {
    try {
      dynamic queryData = {"isin": text, "apikey": Constants.FMP_KEY};

      var response =
          await _client.get("api/v4/search/isin", queryParameters: queryData);

      return (response.data as List<dynamic>)
          .map((e) => FMPISINSearch.fromJson(e as Map<String, dynamic>))
          .where((e) => e.currency != null)
          .toList()
          .map((e) => MarketInfo(
                symbol: e.symbol,
                name: e.companyName,
                currency: e.currency!,
                exchangeName: e.exchange ?? e.exchangeShortName,
                exchangeNameShort: e.exchangeShortName,
              ))
          .toList();
    } catch (e) {
      print("searchTicker error: $e");
      return [];
    }
  }

  @override
  Future<List<FmpSplitHistoricalItem>> getSplitHistorical(String symbol) async {
    try {
      dynamic queryData = {"apikey": Constants.FMP_KEY};

      var response = await _client.get(
          "api/v3/historical-price-full/stock_split/$symbol",
          queryParameters: queryData);

      return FmpSplitHistorical.fromJson(response.data).historical;
    } catch (e) {
      print("searchTicker error: $e");
      return [];
    }
  }
}
