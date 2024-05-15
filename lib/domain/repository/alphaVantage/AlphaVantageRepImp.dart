import 'package:dio/dio.dart';
import 'package:net_worth_manager/models/network/av_quote_model.dart';
import 'package:net_worth_manager/domain/repository/stock/StockApi.dart';

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

      return AVTickerSearch.fromJson(response.data).bestMatches.map((e) => MarketInfo(
          e.symbol, e.name, e.type, e.currency, e.region)).toList();
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
}
