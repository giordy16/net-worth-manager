import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
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

  DateFormat getDateFormat() {
    switch (this) {
      case DataGap.all:
        return DateFormat("MMM yy");
      case DataGap.ytd:
        return DateFormat("dd MMM");
      case DataGap.g60:
        return DateFormat("dd MMM");
      case DataGap.g30:
        return DateFormat("dd MMM");
    }
  }
}

class GraphData {
  DateTime x;
  double y;

  GraphData(this.x, this.y);
}

class AssetLineGraph extends StatefulWidget {
  static DateTime today = DateTime.now();

  Asset asset;
  bool showGapSelection;

  AssetLineGraph({
    super.key,
    required this.asset,
    this.showGapSelection = false,
  });

  @override
  State<StatefulWidget> createState() => _AssetLineGraph();
}

class _AssetLineGraph extends State<AssetLineGraph> {
  DataGap currentGap = DataGap.all;
  List<AssetTimeValue> assetValuesOfGap = [];
  List<GraphData> graphData = [];

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
    graphData =
        assetValuesOfGap.map((e) => GraphData(e.date, e.value)).toList();

    // add a new point so the graph is plotted until the right border
    if (graphData.isNotEmpty) {
      graphData.add(GraphData(DateTime.now(), graphData.last.y));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    initPage();

    if (widget.asset.timeValues.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(
            Dimensions.screenMargin, Dimensions.l, Dimensions.screenMargin, 0),
        child: Center(
            child: Text(
          "Not enough data to plot the chart",
          textAlign: TextAlign.center,
        )),
      );
    }

    return Column(
      children: [
        Visibility(
          visible: widget.showGapSelection,
          child: CustomSlidingSegmentedControl(
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
        ),
        const SizedBox(height: Dimensions.m),
        SfCartesianChart(
          zoomPanBehavior:
              ZoomPanBehavior(enablePinching: true, enablePanning: true),
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              builder: (context, trackballDetails) {
                return Container(
                    width: 100,
                    height: 50,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (trackballDetails.point!.y as double).toStringFormatted(),
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat("dd/MM/yy").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  trackballDetails.point!.x)),
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ));
              }),
          primaryXAxis: NumericAxis(
            minimum: currentGap
                .getStartDate(widget.asset)
                .millisecondsSinceEpoch
                .toDouble(),
            maximum: currentGap.getEndDate().millisecondsSinceEpoch.toDouble(),
            axisLabelFormatter: (AxisLabelRenderDetails details) =>
                ChartAxisLabel(
                    currentGap.getDateFormat().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            (details.value as double).toInt())),
                    details.textStyle),
          ),
          series: [
            SplineSeries<GraphData, int>(
              color: theme.colorScheme.secondary,
              splineType: SplineType.monotonic,
              animationDuration: 100,
              enableTooltip: true,
              markerSettings: const MarkerSettings(isVisible: true),
              dataSource: graphData,
              // trendlines: [
              //   Trendline(
              //     type: TrendlineType.linear,
              //     color: Colors.white,
              //     opacity: 0.2,
              //   )
              // ],
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
