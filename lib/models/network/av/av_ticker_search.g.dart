// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'av_ticker_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AVTickerModel _$AVTickerModelFromJson(Map<String, dynamic> json) =>
    AVTickerModel(
      json['1. symbol'] as String,
      json['2. name'] as String,
      json['3. type'] as String,
      json['8. currency'] as String,
      json['4. region'] as String,
    );

Map<String, dynamic> _$AVTickerModelToJson(AVTickerModel instance) =>
    <String, dynamic>{
      '1. symbol': instance.symbol,
      '2. name': instance.name,
      '3. type': instance.type,
      '8. currency': instance.currency,
      '4. region': instance.region,
    };
