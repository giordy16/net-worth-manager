import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fmp_split_historical.g.dart';

@JsonSerializable()
class FmpSplitHistorical {
  List<FmpSplitHistoricalItem> historical;

  FmpSplitHistorical(this.historical);

  factory FmpSplitHistorical.fromJson(Map<String, dynamic> json) =>
      _$FmpSplitHistoricalFromJson(json);

  Map<String, dynamic> toJson() => _$FmpSplitHistoricalToJson(this);
}

@JsonSerializable()
class FmpSplitHistoricalItem {
  String date;
  int numerator;
  int denominator;

  FmpSplitHistoricalItem(this.date, this.numerator, this.denominator);

  factory FmpSplitHistoricalItem.fromJson(Map<String, dynamic> json) =>
      _$FmpSplitHistoricalItemFromJson(json);

  Map<String, dynamic> toJson() => _$FmpSplitHistoricalItemToJson(this);

  DateTime get dateFormatted {
    return DateFormat("yyyy-MM-dd").parse(date);
  }

}