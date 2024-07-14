import 'package:json_annotation/json_annotation.dart';

part 'fmp_ticker_search.g.dart';

@JsonSerializable()
class FMPTickerSearch {
  String symbol;
  String name;
  String? currency;
  String? stockExchange;
  String? exchangeShortName;

  FMPTickerSearch(this.symbol, this.name, this.currency, this.stockExchange,
      this.exchangeShortName);

  factory FMPTickerSearch.fromJson(Map<String, dynamic> json) =>
      _$FMPTickerSearchFromJson(json);

  Map<String, dynamic> toJson() => _$FMPTickerSearchToJson(this);
}
