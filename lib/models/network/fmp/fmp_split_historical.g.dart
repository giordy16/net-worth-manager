// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fmp_split_historical.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FmpSplitHistorical _$FmpSplitHistoricalFromJson(Map<String, dynamic> json) =>
    FmpSplitHistorical(
      (json['historical'] as List<dynamic>)
          .map(
              (e) => FmpSplitHistoricalItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FmpSplitHistoricalToJson(FmpSplitHistorical instance) =>
    <String, dynamic>{
      'historical': instance.historical,
    };

FmpSplitHistoricalItem _$FmpSplitHistoricalItemFromJson(
        Map<String, dynamic> json) =>
    FmpSplitHistoricalItem(
      json['date'] as String,
      (json['numerator'] as num).toInt(),
      (json['denominator'] as num).toInt(),
    );

Map<String, dynamic> _$FmpSplitHistoricalItemToJson(
        FmpSplitHistoricalItem instance) =>
    <String, dynamic>{
      'date': instance.date,
      'numerator': instance.numerator,
      'denominator': instance.denominator,
    };
