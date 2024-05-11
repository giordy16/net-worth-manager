import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/obox/asset_obox.dart';

enum DataGap { all, ytd, g60, g30 }

extension DataGapExt on DataGap {
  String getName() {
    switch (this) {
      case DataGap.all:
        return "ALL";
      case DataGap.ytd:
        return "YTD";
      case DataGap.g30:
        return "30 D";
      case DataGap.g60:
        return "60 D";
    }
  }

  DateTime getStartDate(Asset asset) {
    switch (this) {
      case DataGap.all:
        return asset.getFirstTimeValueDate()!;
      case DataGap.ytd:
        return DateTime(AssetLineGraph.today.year);
      case DataGap.g60:
        return AssetLineGraph.today.subtract(const Duration(days: 60));
      case DataGap.g30:
        return AssetLineGraph.today.subtract(const Duration(days: 30));
    }
  }

  DateTime getEndDate() {
    return AssetLineGraph.today;
  }
}

class GraphData {
  DateTime x;
  double y;

  GraphData(this.x, this.y);
}

class SalesData {
  SalesData(this.year, this.sales);

  final int year;
  final double sales;
}

class AssetLineGraph extends StatefulWidget {
  static DateTime today = DateTime.now();

  Asset asset;

  AssetLineGraph({super.key, required this.asset});

  @override
  State<StatefulWidget> createState() => _AssetLineGraph();
}

class _AssetLineGraph extends State<AssetLineGraph> {
  DataGap currentGap = DataGap.g30;
  List<AssetTimeValue> assetValuesOfGap = [];
  late AxisTitles bottomAxis;

  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() {
    initValuesOfGap();
  }

  void initValuesOfGap() {
    assetValuesOfGap = widget.asset.getTimeValuesChronologicalOrder();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    initPage();

    return Column(
      children: [
        CustomSlidingSegmentedControl(
          isStretch: true,
          initialValue: DataGap.values.indexOf(currentGap),
          innerPadding: const EdgeInsets.all(Dimensions.xxs),
          children: {
            0: Text(DataGap.all.getName()),
            1: Text(DataGap.ytd.getName()),
            2: Text(DataGap.g60.getName()),
            3: Text(DataGap.g30.getName()),
          },
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(50),
          ),
          thumbDecoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(50),
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInToLinear,
          onValueChanged: (v) {
            setState(() {
              currentGap = DataGap.values[v];
              initPage();
            });
          },
        ),
        const SizedBox(height: Dimensions.m),
        SfCartesianChart(
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enablePanning: true
          ),
          // crosshairBehavior: CrosshairBehavior(
          //   enable: true,
          //   lineDashArray: [5],
          //
          // ),
          trackballBehavior: TrackballBehavior(
            enable: true,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: NumericAxis(
            minimum: currentGap
                .getStartDate(widget.asset)
                .millisecondsSinceEpoch
                .toDouble(),
            maximum: currentGap.getEndDate().millisecondsSinceEpoch.toDouble(),
            axisLabelFormatter: (AxisLabelRenderDetails details) =>
                ChartAxisLabel(
                    DateFormat("dd MMM").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            (details.value as double).toInt())),
                    details.textStyle),
          ),
          series: [
            StepLineSeries<GraphData, int>(
              color: theme.colorScheme.secondary,
              animationDuration: 100,
              enableTooltip: true,
              dataSource: assetValuesOfGap
                  .map((e) => GraphData(e.date, e.value))
                  .toList(),
              xValueMapper: (GraphData data, _) =>
                  data.x.millisecondsSinceEpoch,
              yValueMapper: (GraphData data, _) => data.y,
            )
          ],
        ),
      ],
    );
  }
}
