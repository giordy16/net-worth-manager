// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'YHAutoCompleteResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YHAutoCompleteResponse _$YHAutoCompleteResponseFromJson(
        Map<String, dynamic> json) =>
    YHAutoCompleteResponse(
      (json['data'] as List<dynamic>)
          .map((e) => YHAutoCompleteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String,
    );

Map<String, dynamic> _$YHAutoCompleteResponseToJson(
        YHAutoCompleteResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
    };

YHAutoCompleteModel _$YHAutoCompleteModelFromJson(Map<String, dynamic> json) =>
    YHAutoCompleteModel(
      json['symbol'] as String,
      json['instrument_name'] as String,
      json['exchange'] as String,
      json['instrument_type'] as String,
      json['country'] as String,
      json['currency'] as String,
    );

Map<String, dynamic> _$YHAutoCompleteModelToJson(
        YHAutoCompleteModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'instrument_name': instance.instrument_name,
      'exchange': instance.exchange,
      'instrument_type': instance.instrument_type,
      'country': instance.country,
      'currency': instance.currency,
    };
