import 'package:fl_chart/fl_chart.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../ui/widgets/graph/asset_line_graph.dart';
import '../../ui/widgets/graph/asset_line_graphNEW.dart';
import 'asset_category_obox.dart';

@Entity()
class Asset {
  @Id()
  int id = 0;

  String name;

  ToMany<AssetTimeValue> timeValues = ToMany<AssetTimeValue>();

  ToOne<AssetCategory> category = ToOne<AssetCategory>();

  Asset(this.name);

  DateTime? getLastUpdateDate() {
    return getTimeValuesChronologicalOrder().lastOrNull?.date;
  }

  double? getLastValue() {
    return getTimeValuesChronologicalOrder().lastOrNull?.value;
  }

  DateTime? getFirstTimeValueDate() {
    return getTimeValuesChronologicalOrder().firstOrNull?.date;
  }

  String getLastValueWithCurrency() {
    var lastValue = getLastValue();
    Settings settings = objectbox.store.box<Settings>().getAll().first;

    if (lastValue == null) {
      return "${settings.defaultCurrency.target?.symbol} -";
    } else {
      return "${settings.defaultCurrency.target?.symbol} $lastValue";
    }
  }

  List<AssetTimeValue> getTimeValuesChronologicalOrder({
    bool latestFirst = false,
  }) {
    var values = timeValues.toList();
    values.sort((a, b) =>
        latestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return values;
  }

  List<FlSpot> getGraphData() {
    return getTimeValuesChronologicalOrder()
        .map((e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.value))
        .toList();
  }

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
