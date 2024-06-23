import 'package:flutter/material.dart';
import 'package:net_worth_manager/utils/chart_utils.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartData {
  String title;
  double value;
  double perc;

  PieChartData(this.title, this.value, this.perc);
}

class AllocationPieChart extends StatelessWidget {
  List<PieChartData> data;

  AllocationPieChart(this.data);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 200,
      child: SfCircularChart(
          margin: EdgeInsets.zero,
          tooltipBehavior: TooltipBehavior(
              enable: true,
              animationDuration: 0,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      (point.y as double).toStringWithCurrency(),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.surface),
                    ));
              }),
          series: <CircularSeries>[
            PieSeries<PieChartData, String>(
                animationDuration: 0,
                dataSource: data,
                pointColorMapper: (PieChartData data, slice) =>
                    ChartUtils.getSliceColor(slice),
                xValueMapper: (PieChartData data, _) => data.title,
                yValueMapper: (PieChartData data, _) => data.value,
                dataLabelMapper: (PieChartData data, _) =>
                    "${data.title} | ${data.perc} %",
                radius: "80%",
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelIntersectAction: LabelIntersectAction.shift,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                        type: ConnectorType.curve, length: '10%')))
          ]),
    );
  }
}
