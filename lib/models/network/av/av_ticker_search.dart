import 'package:json_annotation/json_annotation.dart';

part 'av_ticker_search.g.dart';

class AVTickerSearch {
  List<AVTickerModel> bestMatches;

  AVTickerSearch(this.bestMatches);

  factory AVTickerSearch.fromJson(Map<String, dynamic> json) =>
      AVTickerSearch(List<AVTickerModel>.from(
          json["bestMatches"].map((m) => AVTickerModel.fromJson(m))));
}

@JsonSerializable()
class AVTickerModel {
  @JsonKey(name: "1. symbol")
  String symbol;

  @JsonKey(name: "2. name")
  String name;

  @JsonKey(name: "3. type")
  String type;

  @JsonKey(name: "8. currency")
  String currency;

  @JsonKey(name: "4. region")
  String region;

  AVTickerModel(this.symbol, this.name, this.type, this.currency, this.region);

  factory AVTickerModel.fromJson(Map<String, dynamic> json) => _$AVTickerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AVTickerModelToJson(this);

}
