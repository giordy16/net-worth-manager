// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fmp_forex.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FMPForex _$FMPForexFromJson(Map<String, dynamic> json) => FMPForex(
      json['date'] as String,
      (json['close'] as num).toDouble(),
    );

Map<String, dynamic> _$FMPForexToJson(FMPForex instance) => <String, dynamic>{
      'date': instance.date,
      'close': instance.close,
    };
