import 'package:json_annotation/json_annotation.dart';

part 'fmp_isin_search.g.dart';

@JsonSerializable()
class FMPISINSearch {
  String symbol;
  String companyName;
  String? currency;
  String? exchange;
  String? exchangeShortName;

  FMPISINSearch(this.symbol, this.companyName, this.currency, this.exchange,
      this.exchangeShortName);

  factory FMPISINSearch.fromJson(Map<String, dynamic> json) =>
      _$FMPISINSearchFromJson(json);

  Map<String, dynamic> toJson() => _$FMPISINSearchToJson(this);
}
