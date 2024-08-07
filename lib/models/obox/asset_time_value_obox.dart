import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../objectbox.g.dart';

@Entity()
class AssetTimeValue {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  double quantity;

  String? note;

  ToOne<Currency> currency = ToOne<Currency>();

  AssetTimeValue({
    this.id = 0,
    required this.date,
    required this.value,
    this.quantity = 1,
    this.note,
  }) {
    currency.target = GetIt.instance<Settings>().defaultCurrency.target;
  }

  AssetTimeValue.empty(MarketInfo? info)
      : id = 0,
        date = DateTime.now().keepOnlyYMD(),
        value = 0,
        quantity = 1,
        note = null {
    currency.target = GetIt.instance<Settings>().defaultCurrency.target;
  }

  /// get total purchase value (single value * quantity)
  double getTotalPurchaseValue() {
    return double.parse((value * quantity).toStringAsFixed(2));
  }

  /// get current value of the position at main currency
  double getCurrentValue({
    DateTime? date,
    MarketInfo? marketInfo,
  }) {
    if (marketInfo == null) {
      // simple asset
      return (value * quantity)
          .atMainCurrency(fromCurrency: currency.target!.name, dateTime: date);
    } else {
      // market asset
      double symbolValue = GetIt.I<Store>()
              .box<AssetHistoryTimeValue>()
              .query(
                  AssetHistoryTimeValue_.assetSymbol.equals(marketInfo.symbol))
              .order(AssetHistoryTimeValue_.date, flags: Order.descending)
              .build()
              .findFirst()
              ?.value ??
          0;
      return (symbolValue * quantity)
          .atMainCurrency(fromCurrency: marketInfo.currency, dateTime: date);
    }
  }

  double getPerformance(String symbol) {
    String symbolCurrency = GetIt.I<Store>()
        .box<MarketInfo>()
        .query(MarketInfo_.symbol.equals(symbol))
        .build()
        .findFirst()!
        .currency;

    double symbolValue = GetIt.I<Store>()
            .box<AssetHistoryTimeValue>()
            .query(AssetHistoryTimeValue_.assetSymbol.equals(symbol))
            .order(AssetHistoryTimeValue_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.value
            .atMainCurrency(fromCurrency: symbolCurrency) ??
        0;

    var valueMainCurrency = value.atMainCurrency(
        fromCurrency: currency.target!.name, dateTime: date);

    return double.parse(
        ((symbolValue - valueMainCurrency) * quantity).toStringAsFixed(2));
  }

  double getPerformancePerc(String symbol) {
    String symbolCurrency = GetIt.I<Store>()
        .box<MarketInfo>()
        .query(MarketInfo_.symbol.equals(symbol))
        .build()
        .findFirst()!
        .currency;

    double symbolValue = GetIt.I<Store>()
            .box<AssetHistoryTimeValue>()
            .query(AssetHistoryTimeValue_.assetSymbol.equals(symbol))
            .order(AssetHistoryTimeValue_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.value
            .atMainCurrency(fromCurrency: symbolCurrency) ??
        0;

    var valueMainCurrency = value.atMainCurrency(
        fromCurrency: currency.target!.name, dateTime: date);

    return double.parse(
        ((symbolValue - valueMainCurrency) / valueMainCurrency * 100)
            .toStringAsFixed(1));
  }
}

extension AssetTimeValueHelper on AssetTimeValue {
  AssetTimeValue duplicate() {
    AssetTimeValue assetTime = AssetTimeValue(
      id: id,
      date: date,
      value: value,
      quantity: quantity,
    );
    assetTime.currency.target = currency.target;
    return assetTime;
  }
}
