import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../models/ui/graph_data.dart';
import '../../../utils/enum/graph_data_gap_enum.dart';

class SimpleAssetLineGraph extends StatefulWidget {
  static DateTime today = DateTime.now();

  Asset asset;
  bool showGapSelection;
  List<GraphData> graphData;

  SimpleAssetLineGraph({
    super.key,
    required this.asset,
    required this.graphData,
    this.showGapSelection = false,
  });

  @override
  State<StatefulWidget> createState() => _AssetLineGraph();
}

class _AssetLineGraph extends State<SimpleAssetLineGraph> {
  GraphTime currentGap = GraphTime.all;
  List<AssetTimeValue> assetValuesOfGap = [];

  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() {
    initValuesOfGap();

    // add a value at the end so the graph is plotted until the end
    if (widget.graphData.isNotEmpty) {
      widget.graphData.add(GraphData(DateTime.now(), widget.graphData.last.y));
    }
  }

  void initValuesOfGap() {
    assetValuesOfGap = widget.asset.getTimeValuesChronologicalOrder();
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
            initialValue: GraphTime.values.indexOf(currentGap),
            innerPadding: const EdgeInsets.all(Dimensions.xxs),
            children: {
              0: Text(GraphTime.all.getName()),
              1: Text(GraphTime.ytd.getName()),
              2: Text(GraphTime.threeMonths.getName()),
              3: Text(GraphTime.oneMonth.getName()),
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
              dataSource: widget.graphData,
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
