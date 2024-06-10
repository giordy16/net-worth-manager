import 'dart:math';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../models/ui/graph_data.dart';
import '../../../utils/enum/graph_data_gap_enum.dart';

class LineGraph extends StatefulWidget {
  static DateTime today = DateTime.now();

  bool showGapSelection;
  List<GraphData> graphData;
  List<GraphData>? secondaryGraphData;
  Function(GraphTime)? onGraphTimeChange;
  GraphTime initialGap;

  LineGraph({
    super.key,
    required this.graphData,
    this.secondaryGraphData,
    this.showGapSelection = false,
    this.onGraphTimeChange,
    this.initialGap = GraphTime.all,
  });

  @override
  State<StatefulWidget> createState() => _MarketAssetLineGraph();
}

class _MarketAssetLineGraph extends State<LineGraph> {
  late GraphTime currentGap;
  List<AssetTimeValue> assetValuesOfGap = [];

  @override
  void initState() {
    currentGap = widget.initialGap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (widget.graphData.isEmpty) {
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

    double minX = currentGap
        .getStartDate(widget.graphData.firstOrNull?.x)
        .millisecondsSinceEpoch
        .toDouble();
    double maxX = currentGap.getEndDate().millisecondsSinceEpoch.toDouble();

    // add a new point if the last one is not today, so the graph is plotted until the right edge
    if (widget.graphData.isNotEmpty &&
        widget.graphData.lastOrNull?.x.keepOnlyYMD() !=
            DateTime.now().keepOnlyYMD()) {
      widget.graphData.add(
          GraphData(DateTime.now().keepOnlyYMD(), widget.graphData.last.y));
      if (widget.secondaryGraphData != null) {
        widget.secondaryGraphData!.add(GraphData(
            DateTime.now().keepOnlyYMD(), widget.secondaryGraphData!.last.y));
      }
    }

    // edge case: graphData has only 1 element and has the date of today
    // solution: add to graphData the date of tomorrow
    if (widget.graphData.length == 1 &&
        widget.graphData.lastOrNull?.x == DateTime.now().keepOnlyYMD()) {
      DateTime todayLastDateTime = DateTime.now()
          .keepOnlyYMD()
          .add(Duration(days: 1))
          .subtract(Duration(milliseconds: 1));

      widget.graphData
          .add(GraphData(todayLastDateTime, widget.graphData.last.y));
      if (widget.secondaryGraphData != null) {
        widget.secondaryGraphData!.add(
            GraphData(todayLastDateTime, widget.secondaryGraphData!.last.y));
      }
      maxX = todayLastDateTime.millisecondsSinceEpoch.toDouble();
    }

    return Column(
      children: [
        Visibility(
          visible: widget.showGapSelection,
          child: CustomSlidingSegmentedControl(
            isStretch: true,
            initialValue: GraphTime.values.indexOf(currentGap),
            innerPadding: const EdgeInsets.all(Dimensions.xxs),
            children: {
              0: Text(GraphTime.all.getName()),
              1: Text(GraphTime.fiveYears.getName()),
              2: Text(GraphTime.oneYear.getName()),
              3: Text(GraphTime.ytd.getName()),
              4: Text(GraphTime.threeMonths.getName()),
              5: Text(GraphTime.oneMonth.getName()),
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
                currentGap = GraphTime.values[v];
              });
              if (widget.onGraphTimeChange != null) {
                widget.onGraphTimeChange!(currentGap);
              }
            },
          ),
        ),
        const SizedBox(height: Dimensions.m),
        SizedBox(
          height: 350,
          child: SfCartesianChart(
            margin: EdgeInsets.zero,
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            zoomPanBehavior:
                ZoomPanBehavior(enablePinching: true, enablePanning: true),
            trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
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
                            (trackballDetails.point!.y as double)
                                .toStringFormatted(),
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
              minimum: minX,
              maximum: maxX,
              axisLabelFormatter: (AxisLabelRenderDetails details) =>
                  ChartAxisLabel(
                      currentGap.getDateFormat().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (details.value as double).toInt())),
                      details.textStyle),
            ),
            primaryYAxis: NumericAxis(
              maximum:
                  widget.graphData.map((element) => element.y).reduce(max) + 25,
              minimum:
                  widget.graphData.map((element) => element.y).reduce(min) - 25,
              axisLabelFormatter: (AxisLabelRenderDetails details) =>
                  ChartAxisLabel(NumberFormat.compact().format(details.value),
                      details.textStyle),
            ),
            series: [
              LineSeries<GraphData, int>(
                name: "Asset value",
                color: theme.colorScheme.secondary,
                animationDuration: 100,
                // enableTooltip: true,
                dataSource: widget.graphData,
                xValueMapper: (GraphData data, _) =>
                    data.x.millisecondsSinceEpoch,
                yValueMapper: (GraphData data, _) => data.y,
              ),
              if (widget.secondaryGraphData != null)
                StepLineSeries<GraphData, int>(
                  name: "Money invested",
                  color: Colors.grey,
                  enableTooltip: false,
                  dashArray: const [5, 5],
                  animationDuration: 100,
                  dataSource: widget.secondaryGraphData,
                  xValueMapper: (GraphData data, _) =>
                      data.x.millisecondsSinceEpoch,
                  yValueMapper: (GraphData data, _) => data.y,
                )
            ],
          ),
        ),
      ],
    );
  }
}
