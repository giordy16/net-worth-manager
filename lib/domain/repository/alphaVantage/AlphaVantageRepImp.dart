import 'package:get/get_connect/connect.dart';
import 'package:net_worth_manager/data/alphavantage/quote/QuoteModel.dart';
import 'package:net_worth_manager/data/alphavantage/tickerSearch/TickerSearchModel.dart';
import 'package:net_worth_manager/domain/repository/alphaVantage/AlphaVantageRep.dart';

import '../../../data/ProductEntity.dart';
import '../../../utils/Constants.dart';

class AlphaVantageRepImp extends GetConnect implements AlphaVantageRep {
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
      return TickerSearchList.fromJson(response.body)
          .bestMatches
          .map((e) => ProductEntity(e.name, e.symbol, e.type, e.currency, 0))
          .toList();
    } catch (e) {
      print("searchTicker error: $e");
      return null;
    }
  }

  @override
  Future<QuoteModel?> getLastPriceBySymbol(String symbol) async {
    try {
      dynamic queryData = {
        "function": "GLOBAL_QUOTE",
        "symbol": Uri.encodeFull(symbol),
        "apikey": Constants.ALPHA_VANTAGE_KEY
      };

      var response = await get("query", query: queryData);
      print(response.request?.url);
      return QuoteList.fromJson(response.body).quote;
    } catch (e) {
      print("getLastPriceBySymbol error: $e");
      return null;
    }
  }
}
