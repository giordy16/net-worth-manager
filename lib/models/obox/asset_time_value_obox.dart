import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../utils/forex.dart';

@Entity()
class AssetTimeValue {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  double quantity;

  ToOne<Currency> currency = ToOne<Currency>();

  AssetTimeValue(
      {this.id = 0,
      required this.date,
      required this.value,
      this.quantity = 1});

  AssetTimeValue.empty(MarketInfo? info)
      : id = 0,
        date = DateTime.now().keepOnlyYMD(),
        value = 0,
        quantity = 1 {
    currency.target = GetIt.instance<Settings>().defaultCurrency.target;
  }

  String getValueWithCurrency() {
    return "${currency.target!.symbol} ${(value * quantity).toStringFormatted()}";
  }

  double getValueAtMainCurrency([DateTime? date]) {
    double change = Forex.getCurrencyChange(currency.target!.name, date: date);
    return double.parse((change * value * quantity).toStringAsFixed(2));
  }

  double getPerformance(double currentValue) {
    return double.parse(((currentValue - value) * quantity).toStringAsFixed(2));
  }

  double getPerformancePerc(double currentValue) {
    return double.parse(
        ((currentValue - value) / value * 100).toStringAsFixed(2));
  }

  String getPerformancePercString(double currentValue) {
    return "${getPerformancePerc(currentValue)}%";
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
