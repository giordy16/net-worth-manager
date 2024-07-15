import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../i18n/strings.g.dart';

class ColumnGraphData {
  String x;
  double y;

  ColumnGraphData(this.x, this.y);
}

class GainLossesChart extends StatelessWidget {
  List<ColumnGraphData>? chartData;
  DateTime? start;
  DateTime? end;

  GainLossesChart(this.chartData, this.start, this.end, {super.key});

  @override
  Widget build(BuildContext context) {
    if (chartData == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (chartData!.isEmpty) {
      return Center(
          child: Text(
        t.gain_losses_empty,
        textAlign: TextAlign.center,
      ));
    }

    if (start != null && end != null) {
      // filter chartData
      chartData = chartData!.where((element) {
        var date = DateFormat("MMM yy").parse(element.x);
        return (date.isAfter(start!) || date.isAtSameMomentAs(start!)) &&
            (date.isBefore(end!) || date.isAtSameMomentAs(end!));
      }).toList();
    }

    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.xy,
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    (point.y as double).toStringWithCurrency(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface),
                  ));
            }),
        series: [
          ColumnSeries<ColumnGraphData, String>(
            animationDuration: 200,
            dataSource: chartData,
            xValueMapper: (ColumnGraphData data, _) => data.x,
            yValueMapper: (ColumnGraphData data, _) => data.y,
            pointColorMapper: (ColumnGraphData data, _) =>
                data.y > 0 ? Colors.green : Colors.red,
          )
        ],
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(anchorRangeToVisiblePoints: false),
      ),
    );
  }
}
