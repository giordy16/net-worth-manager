import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/app_dimensions.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/graph/allocation_pie_chart.dart';

class FullAssetAllocationScreen extends StatelessWidget {
  static String route = "FullAssetAllocationScreen";

  @override
  Widget build(BuildContext context) {
    final categories = GetIt.I<Store>()
        .box<AssetCategory>()
        .getAll()
        .where((cat) => cat.getValue() > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("Asset allocation"),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
          child: ListView(
              children: categories.map((cat) {
            final assets = cat.getAssets().where((a) => a.getCurrentValue() > 0).toList();

            assets.sort(
                (a, b) => b.getCurrentValue().compareTo(a.getCurrentValue()));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                AllocationPieChart(assets
                    .map((asset) => PieChartData(
                        asset.name,
                        asset.getCurrentValue(),
                        double.parse(
                            (asset.getCurrentValue() / cat.getValue() * 100)
                                .toStringAsFixed(1))))
                    .toList()),
                SizedBox(height: Dimensions.l),
              ],
            );
          }).toList()),
        ),
      ),
    );
  }
}
