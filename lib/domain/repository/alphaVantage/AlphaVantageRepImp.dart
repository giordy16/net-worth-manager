import 'package:get/get_connect/connect.dart';
import 'package:net_worth_manager/data/alphavantage/quote/AVQuoteModel.dart';
import 'package:net_worth_manager/data/alphavantage/tickerSearch/AVTickerSearchModel.dart';
import 'package:net_worth_manager/domain/repository/stock/StockApi.dart';

import '../../../data/ProductEntity.dart';
import '../../../utils/Constants.dart';

class AlphaVantageRepImp extends GetConnect implements StockApi {
  @override
  void onInit() {
    httpClient.baseUrl = Constants.ALPHA_VANTAGE_BASE_URL;
    super.onInit();
  }

  @override
  Future<List<ProductEntity>?> searchTicker(String text) async {
    try {
      dynamic queryData = {
        "function": "SYMBOL_SEARCH",
        "keywords": Uri.encodeFull(text),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      var response = await get("query", query: queryData);
      print(response.request?.url);
      return AVTickerSearchList.fromJson(response.body)
          .bestMatches
          .map((e) => ProductEntity(e.name, e.symbol, e.type, 0, 0,
              currency: e.currency))
          .toList();
    } catch (e) {
      print("searchTicker error: $e");
      return null;
    }
  }

  @override
  Future<AVQuoteModel?> getLastPriceBySymbol(String symbol) async {
    try {
      dynamic queryData = {
        "function": "GLOBAL_QUOTE",
        "symbol": Uri.encodeFull(symbol),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      var response = await get("query", query: queryData);
      print(response.request?.url);
      return AVQuoteList.fromJson(response.body).quote;
    } catch (e) {
      print("getLastPriceBySymbol error: $e");
      return null;
    }
  }
}
