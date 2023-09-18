class AVTickerSearchList {
  List<AVTickerSearchModel> bestMatches;

  AVTickerSearchList(this.bestMatches);

  factory AVTickerSearchList.fromJson(Map<String, dynamic> json) => AVTickerSearchList(
      List<AVTickerSearchModel>.from(json["bestMatches"].map((m) => AVTickerSearchModel.fromJson(m))));
}

class AVTickerSearchModel {
  String symbol;
  String name;
  String type;
  String region;
  String currency;

  AVTickerSearchModel(this.symbol, this.name, this.type, this.region, this.currency);

  factory AVTickerSearchModel.fromJson(Map<String, dynamic> json) => AVTickerSearchModel(
        json["1. symbol"],
        json["2. name"],
        json["3. type"],
        json["4. region"],
        json["8. currency"],
      );
}
