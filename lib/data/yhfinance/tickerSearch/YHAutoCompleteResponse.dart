import 'package:json_annotation/json_annotation.dart';

part 'YHAutoCompleteResponse.g.dart';

@JsonSerializable()
class YHAutoCompleteResponse {
  List<YHAutoCompleteModel> data;
  String status;

  YHAutoCompleteResponse(this.data, this.status);

  factory YHAutoCompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$YHAutoCompleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$YHAutoCompleteResponseToJson(this);
}

@JsonSerializable()
class YHAutoCompleteModel {
  String symbol;
  String instrument_name;
  String exchange;
  String instrument_type;
  String country;
  String currency;

  YHAutoCompleteModel(this.symbol, this.instrument_name, this.exchange,
      this.instrument_type, this.country, this.currency);

  factory YHAutoCompleteModel.fromJson(Map<String, dynamic> json) =>
      _$YHAutoCompleteModelFromJson(json);

  Map<String, dynamic> toJson() => _$YHAutoCompleteModelToJson(this);
}