import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class NewGraphWidget extends StatefulWidget {
  static String route = "/NewGraphWidget";

  @override
  State<NewGraphWidget> createState() => _NewGraphWidgetState();
}

class _NewGraphWidgetState extends State<NewGraphWidget> {
  intl.DateFormat hmFormat = intl.DateFormat('dd MMM yy');
  double _maxX = 0;
  double _minX = 0;
  double middle = 0;

  final data = [
    FlSpot(1693811005000 / 1000 / 60, 7.59659),
    FlSpot(1693810765000 / 1000 / 60, 8.74324),
    FlSpot(1693810704000 / 1000 / 60, 10.8216),
    FlSpot(1693810645000 / 1000 / 60, 40.8216),
    FlSpot(1693810285000 / 1000 / 60, 6.87993),
    FlSpot(1693810105000 / 1000 / 60, 5.94827),
    FlSpot(1693809804000 / 1000 / 60, 7.02326),
    FlSpot(1693809744000 / 1000 / 60, 7.09493),
    FlSpot(1693809685000 / 1000 / 60, 6.0916),
    FlSpot(1693809625000 / 1000 / 60, 0.15662),
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _maxX = double.parse(
        data.map<double>((e) => (e.x)).reduce(max).toStringAsFixed(0));
    _minX = double.parse(
        data.map<double>((e) => e.x).reduce(min).toStringAsFixed(0));
    middle = double.parse(data[data.length ~/ 2].x.toStringAsFixed(0)) + 4;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: AspectRatio(
            aspectRatio: 2,
            child: LineChart(
              LineChartData(
                maxY: 50,
                minY: 0,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                    left: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                    right: const BorderSide(color: Colors.transparent),
                    top: const BorderSide(color: Colors.transparent),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: getBottomTitles(),
                  topTitles: noTitlesWidget(),
                  leftTitles: noTitlesWidget(),
                  rightTitles: noTitlesWidget(),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.cyan,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    spots: data,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AxisTitles getBottomTitles() {
    return AxisTitles(
      axisNameSize: 200,
      sideTitles: SideTitles(
         reservedSize: 100,
        interval: 5,
        showTitles: true,
        getTitlesWidget: (value, meta) {

          if (meta.axisPosition == 0 ||
              meta.axisPosition == meta.parentAxisSize) {
            // don't show first and last values
            return const SizedBox();
          }
          return SideTitleWidget(
            angle: -45,
              axisSide: meta.axisSide,
              child: Text(
                "!"
                // getDate(value),
              ));
        },
      ),
    );
  }

  String getDate(double value) {
    return hmFormat.format(
        DateTime.fromMillisecondsSinceEpoch((value * 1000 * 60).toInt()));
  }

  AxisTitles noTitlesWidget() {
    return const AxisTitles(sideTitles: SideTitles());
  }
}
