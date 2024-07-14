// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fmp_isin_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FMPISINSearch _$FMPISINSearchFromJson(Map<String, dynamic> json) =>
    FMPISINSearch(
      json['symbol'] as String,
      json['companyName'] as String,
      json['currency'] as String?,
      json['exchange'] as String?,
      json['exchangeShortName'] as String?,
    );

Map<String, dynamic> _$FMPISINSearchToJson(FMPISINSearch instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'companyName': instance.companyName,
      'currency': instance.currency,
      'exchange': instance.exchange,
      'exchangeShortName': instance.exchangeShortName,
    };
