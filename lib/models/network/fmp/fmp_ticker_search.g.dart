// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fmp_ticker_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FMPTickerSearch _$FMPTickerSearchFromJson(Map<String, dynamic> json) =>
    FMPTickerSearch(
      json['symbol'] as String,
      json['name'] as String,
      json['currency'] as String?,
      json['stockExchange'] as String?,
      json['exchangeShortName'] as String?,
    );

Map<String, dynamic> _$FMPTickerSearchToJson(FMPTickerSearch instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'currency': instance.currency,
      'stockExchange': instance.stockExchange,
      'exchangeShortName': instance.exchangeShortName,
    };
