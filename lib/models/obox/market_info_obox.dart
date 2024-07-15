import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';

import '../../objectbox.g.dart';

@Entity()
class MarketInfo {
  @Id()
  int? id = 0;

  String symbol;
  String name;
  String currency;

  String? type;
  String? region;
  String? exchangeName;
  String? exchangeNameShort;

  @Property(type: PropertyType.date)
  DateTime? dateLastPriceFetch;

  MarketInfo({
    required this.symbol,
    required this.name,
    required this.currency,
    this.type,
    this.region,
    this.exchangeName,
    this.exchangeNameShort,
  });

  double getCurrentPrice() {
    return GetIt.I<Store>()
            .box<AssetHistoryTimeValue>()
            .query(AssetHistoryTimeValue_.assetSymbol.equals(symbol))
            .order(AssetHistoryTimeValue_.date, flags: Order.descending)
            .build()
            .findFirst()
            ?.value ??
        0;
  }
}
