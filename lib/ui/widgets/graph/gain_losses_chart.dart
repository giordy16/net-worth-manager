import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnGraphData {
  String x;
  double y;

  ColumnGraphData(this.x, this.y);
}

class GainLossesChart extends StatelessWidget {

  List<ColumnGraphData>? chartData;

  GainLossesChart(this.chartData);

  Widget build(BuildContext context) {

    if (chartData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 250,
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.xy,
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
                int seriesIndex) {
              return Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    (point.y as double).toStringWithCurrency(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.surface),
                  ));
            }),
        series: [
          ColumnSeries<ColumnGraphData, String>(
            dataSource: chartData,
            xValueMapper: (ColumnGraphData data, _) => data.x,
            yValueMapper: (ColumnGraphData data, _) => data.y,
            pointColorMapper: (ColumnGraphData data, _) =>
                data.y > 0 ? Colors.green : Colors.red,
          )
        ],
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            anchorRangeToVisiblePoints: false),
      ),
    );
  }
}
