import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

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
    initAxis();
  }

  void initValuesOfGap() {
    assetValuesOfGap = widget.asset.getTimeValuesByDate(currentGap);
  }

  void initAxis() {
    late double interval;
    late DateFormat df;

    interval = currentGap
            .getEndDate()
            .difference(currentGap.getStartDate(widget.asset))
            .inMinutes
            .toDouble() /
        5;

    switch (currentGap) {
      case DataGap.all:
        df = DateFormat("MMM yy");
        break;
      case DataGap.ytd:
        df = DateFormat("MMM yy");
        break;
      case DataGap.g60:
        df = DateFormat("dd MMM");
        break;
      case DataGap.g30:
        df = DateFormat("dd MMM");
        break;
    }

    bottomAxis = AxisTitles(
        sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 30,
      interval: interval,
      getTitlesWidget: (value, meta) {
        if (meta.axisPosition == 0 ||
            meta.axisPosition == meta.parentAxisSize) {
          // don't show first and last values
          return const SizedBox();
        }

        return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(
              // "!"
              df.format(DateTime.fromMillisecondsSinceEpoch(
                  (value * 1000 * 60).toInt())),
            ));
      },
    ));
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
        AspectRatio(
          aspectRatio: 2.0,
          child: LineChart(
            duration: const Duration(milliseconds: 300),
            LineChartData(
              // minX: currentGap.getStartDate(widget.asset).getMinutesFromEpoch(),
              // maxX: currentGap.getEndDate().getMinutesFromEpoch(),
              lineBarsData: [
                LineChartBarData(
                    dotData: const FlDotData(show: false),
                    spots: assetValuesOfGap
                        .map((e) =>
                            FlSpot(e.date.getMinutesFromEpoch(), e.value))
                        .toList(),
                    color: theme.colorScheme.primary,
                    isCurved: true,
                    preventCurveOverShooting: true
                    // isStrokeCapRound: true,
                    // belowBarData: BarAreaData(show: false),
                    ),
              ],
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: bottomAxis,
              ),
            ),
          ),
        )
      ],
    );
  }
}
