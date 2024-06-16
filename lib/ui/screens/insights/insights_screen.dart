import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../app_dimensions.dart';
import '../../../objectbox.g.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final categories = GetIt.I<Store>().box<AssetCategory>().getAll();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              Text(
                "Allocation by categories",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                  child: SfCircularChart(
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<AssetCategory, String>(
                            dataSource: categories,
                            pointColorMapper:(AssetCategory data,  _) => Colors.blue,
                            xValueMapper: (AssetCategory data, _) => data.name,
                            yValueMapper: (AssetCategory data, _) => data.getValue()
                        )
                      ]
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
