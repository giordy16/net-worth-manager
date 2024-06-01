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

class LineGraph extends StatefulWidget {
  static DateTime today = DateTime.now();

  bool showGapSelection;
  List<GraphData> graphData;

  LineGraph({
    super.key,
    required this.graphData,
    this.showGapSelection = false,
  });

  @override
  State<StatefulWidget> createState() => _MarketAssetLineGraph();
}

class _MarketAssetLineGraph extends State<LineGraph> {
  GraphTime currentGap = GraphTime.all;
  List<AssetTimeValue> assetValuesOfGap = [];

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
            },
          ),
        ),
        const SizedBox(height: Dimensions.m),
        SfCartesianChart(
          margin: EdgeInsets.zero,
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
            minimum: currentGap
                .getStartDate(widget.graphData.firstOrNull?.x)
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
          primaryYAxis: NumericAxis(
            axisLabelFormatter: (AxisLabelRenderDetails details) =>
                ChartAxisLabel(NumberFormat.compact().format(details.value),
                    details.textStyle),
          ),
          series: [
            SplineSeries<GraphData, int>(
              color: theme.colorScheme.secondary,
              splineType: SplineType.monotonic,
              animationDuration: 0,
              enableTooltip: true,
              dataSource: widget.graphData,
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
