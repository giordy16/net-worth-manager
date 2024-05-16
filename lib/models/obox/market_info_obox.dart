import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../objectbox.g.dart';

@Entity()
class MarketInfo {
  @Id()
  int? id = 0;

  String symbol;
  String name;
  String type;
  String currency;
  String region;
  double value;

  ToMany<AssetHistoryTimeValue> historyValue = ToMany<AssetHistoryTimeValue>();

  MarketInfo(
    this.symbol,
    this.name,
    this.type,
    this.currency,
    this.region, {
    this.value = 0,
  });

  /// if @latestFirst is false, the oldest value is the first of the list, otherwise the last
  List<AssetHistoryTimeValue> getHistoryChronologicalOrder({
    bool latestFirst = false,
  }) {
    var values = historyValue.toList();
    values.sort((a, b) =>
        latestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return values;
  }

  Currency getCurrency() {
    return objectbox.store
        .box<Currency>()
        .query(Currency_.name.equals(currency))
        .build()
        .find()
        .first;
  }

  double getCurrentValueAtMainCurrency() {
    String mainCurrency = objectbox.store
        .box<Settings>()
        .getAll()
        .first
        .defaultCurrency
        .target!
        .name;

    double change = currencyChange["$currency$mainCurrency"] ?? 0;
    return double.parse((change * value).toStringAsFixed(2));
  }
}
