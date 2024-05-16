import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';

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

  double getValueAtMainCurrency() {
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
