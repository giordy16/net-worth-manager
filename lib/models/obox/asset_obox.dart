import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../ui/widgets/graph/asset_line_graph.dart';
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
      return double.parse((marketInfo.target!.value * getTotalQuantity()).toStringAsFixed(2));
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

  List<AssetTimeValue> getTimeValuesChronologicalOrder({
    bool latestFirst = false,
  }) {
    var values = timeValues.toList();
    values.sort((a, b) =>
        latestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return values;
  }

  // List<FlSpot> getGraphData() {
  //   return getTimeValuesChronologicalOrder()
  //       .map((e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.value))
  //       .toList();
  // }

  List<AssetTimeValue> getTimeValuesByDate(DataGap gap) {
    DateTime endDate = gap.getEndDate();
    DateTime startDate = gap.getStartDate(this);

    return getTimeValuesChronologicalOrder()
        .where((value) =>
            (value.date.isAfter(startDate) ||
                value.date.isAtSameMomentAs(startDate)) &&
            (value.date.isBefore(endDate) ||
                value.date.isAtSameMomentAs(endDate)))
        .toList();
  }
}
