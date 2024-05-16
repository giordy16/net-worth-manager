import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:objectbox/objectbox.dart';

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
}
