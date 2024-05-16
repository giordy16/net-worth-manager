import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../ui/widgets/graph/simple_asset_line_graph.dart';
import '../../utils/enum/graph_data_gap_enum.dart';
import 'asset_category_obox.dart';

@Entity()
class Asset {
  @Id()
  int id = 0;

  String name;

  ToMany<AssetTimeValue> timeValues = ToMany<AssetTimeValue>();

  ToOne<AssetCategory> category = ToOne<AssetCategory>();

  ToOne<MarketInfo> marketInfo = ToOne<MarketInfo>();

  Asset(this.name);

  DateTime? getLastUpdateDate() {
    return getTimeValuesChronologicalOrder().lastOrNull?.date;
  }

  /// for simple asset (marketInfo == null) the current value is just
  /// the last value inserted by the user.
  /// for market asset (marketInfo != null) the current value is the current
  /// market value multiplied by the total quantity.
  double getCurrentValue() {
    if (marketInfo.target == null) {
      // simple asset, just look the last value inserted by the user
      return getTimeValuesChronologicalOrder().lastOrNull?.value ?? 0;
    } else {
      // market asset, need to look to market value
      return double.parse(
          (marketInfo.target!.value * getTotalQuantity()).toStringAsFixed(2));
    }
  }

  double getTotalQuantity() {
    double q = 0;
    for (var element in timeValues) {
      q = q + element.quantity;
    }
    return q;
  }

  DateTime? getFirstTimeValueDate() {
    return getTimeValuesChronologicalOrder().firstOrNull?.date;
  }

  String getCurrentValueWithCurrency() {
    var lastValue = getCurrentValue();
    Settings settings = objectbox.store.box<Settings>().getAll().first;

    return "${settings.defaultCurrency.target?.symbol} ${lastValue.toStringFormatted()}";
  }

  /// if @latestFirst is false, the oldest value is the first of the list, otherwise the last
  List<AssetTimeValue> getTimeValuesChronologicalOrder({
    bool latestFirst = false,
  }) {
    var values = timeValues.toList();
    values.sort((a, b) =>
        latestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return values;
  }

  double getQuantityAtDateTime(DateTime dateTime) {
    var subList = getTimeValuesChronologicalOrder()
        .where((element) =>
            element.date.isBefore(dateTime.add(const Duration(days: 1))))
        .toList();
    double q = 0;
    for (var element in subList) {
      q = q + element.quantity;
    }
    return q;
  }

  double getValueAtDateTime(DateTime dateTime) {
    if (marketInfo.target == null) {
      // simple asset
      return getTimeValuesChronologicalOrder()
              .where((element) => element.date
                  .isBefore(dateTime.add(const Duration(days: 1))))
              .lastOrNull
              ?.value ??
          0;
    } else {
      // market asset
      var marketValueAtTime = marketInfo.target!.historyValue
              .where((element) => element.date
                  .isBefore(dateTime.add(const Duration(days: 1))))
              .lastOrNull
              ?.value ??
          0;

      return double.parse((marketValueAtTime * getQuantityAtDateTime(dateTime))
          .toStringAsFixed(2));
    }
  }
}
