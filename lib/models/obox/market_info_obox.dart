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

  Currency getCurrency() {
    return objectbox.store
        .box<Currency>()
        .query(Currency_.name.equals(currency))
        .build()
        .find()
        .first;
  }
}
