// import 'package:get/get_connect/connect.dart';
// import 'package:net_worth_manager/data/alphavantage/quote/av_quote_model.dart';
// import 'package:net_worth_manager/data/yhfinance/tickerSearch/YHAutoCompleteResponse.dart';
// import 'package:net_worth_manager/domain/repository/stock/stock_api.dart';
//
// import '../../../data/ProductEntity.dart';
// import '../../../utils/constants.dart';
//
// class YHFinanceRepImp extends GetConnect implements StockApi {
//   @override
//   void onInit() {
//     httpClient.baseUrl = Constants.YH_FINANCE_BASE_URL;
//     super.onInit();
//   }
//
//   @override
//   Future<List<ProductEntity>?> searchTicker(String text) async {
//     try {
//       dynamic queryData = {"symbol": text};
//
//       dynamic header = {
//         "X-RapidAPI-Key": Constants.YH_FINANCE_KEY,
//         'X-RapidAPI-Host': 'twelve-data1.p.rapidapi.com'
//       };
//
//       var response =
//           await get("symbol_search", query: queryData, headers: header);
//
//       print(response.request?.url);
//       print(response.body);
//
//       return YHAutoCompleteResponse.fromJson(response.body)
//           .data
//           .map((e) => ProductEntity(
//               e.instrument_name, e.symbol, e.instrument_type, 0, 0,
//               currency: e.currency, country: e.country, exchange: e.exchange))
//           .toList();
//     } catch (e) {
//       print("searchTicker error: $e");
//       return null;
//     }
//   }
//
//   @override
//   Future<AVQuoteModel?> getLastPriceBySymbol(String symbol) async {
//     try {
//       dynamic queryData = {
//         "function": "GLOBAL_QUOTE",
//         "symbol": Uri.encodeFull(symbol),
//         "apikey": Constants.ALPHA_VANTAGE_KEY
//       };
//
//       var response = await get("query", query: queryData);
//       print(response.request?.url);
//       return AVQuoteList.fromJson(response.body).quote;
//     } catch (e) {
//       print("getLastPriceBySymbol error: $e");
//       return null;
//     }
//   }
// }
