import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:net_worth_manager/utils/forex.dart';
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

  @Property(type: PropertyType.date)
  DateTime? dateLastPriceFetch;

  MarketInfo(
    this.symbol,
    this.name,
    this.type,
    this.currency,
    this.region,
  );

  double getCurrentPrice() {
    return GetIt.I<Store>()
            .box<AssetHistoryTimeValue>()
            .query(AssetHistoryTimeValue_.assetName.equals(symbol))
            .order(AssetHistoryTimeValue_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.value ??
        0;
  }
}
