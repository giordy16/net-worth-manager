import 'package:json_annotation/json_annotation.dart';

part 'fmp_forex.g.dart';

@JsonSerializable()
class FMPForex {
  String date;
  double close;

  FMPForex(this.date, this.close);

  factory FMPForex.fromJson(Map<String, dynamic> json) =>
      _$FMPForexFromJson(json);

  Map<String, dynamic> toJson() => _$FMPForexToJson(this);
}
