import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:objectbox/objectbox.dart';

import '../../ui/widgets/graph/allocation_pie_chart.dart';
import 'asset_obox.dart';

@Entity()
class CustomPie {
  @Id()
  int id = 0;

  String name;

  ToMany<Asset> assets = ToMany<Asset>();

  ToMany<AssetCategory> categories = ToMany<AssetCategory>();

  CustomPie(this.name);

  double getTotalValue() {
    double value = 0.0;

    assets.forEach((element) => value = value + element.getCurrentValue());
    categories.forEach((element) => value = value + element.getValue());

    return double.parse(value.toStringAsFixed(2));
  }

  List<PieChartData> getChartData() {
    List<PieChartData> list = [];

    list.addAll(assets
        .map((element) => PieChartData(
              element.name,
              element.getCurrentValue(),
              double.parse((element.getCurrentValue() / getTotalValue() * 100)
                  .toStringAsFixed(2)),
            ))
        .toList());

    list.addAll(categories
        .map((element) => PieChartData(
              element.name,
              element.getValue(),
              double.parse((element.getValue() / getTotalValue() * 100)
                  .toStringAsFixed(2)),
            ))
        .toList());

    list.sort((a, b) => b.value.compareTo(a.value));

    return list;
  }
}
