class TickerSearchList {
  List<TickerSearchModel> bestMatches;

  TickerSearchList(this.bestMatches);

  factory TickerSearchList.fromJson(Map<String, dynamic> json) => TickerSearchList(
      List<TickerSearchModel>.from(json["bestMatches"].map((m) => TickerSearchModel.fromJson(m))));
}

class TickerSearchModel {
  String symbol;
  String name;
  String type;
  String region;
  String currency;

  TickerSearchModel(this.symbol, this.name, this.type, this.region, this.currency);

  factory TickerSearchModel.fromJson(Map<String, dynamic> json) => TickerSearchModel(
        json["1. symbol"],
        json["2. name"],
        json["3. type"],
        json["4. region"],
        json["8. currency"],
      );
}
