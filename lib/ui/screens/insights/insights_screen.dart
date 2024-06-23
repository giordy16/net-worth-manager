import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/ui/screens/insights/full_asset_allocation_screen.dart';
import 'package:net_worth_manager/ui/widgets/graph/allocation_pie_chart.dart';

import '../../../app_dimensions.dart';
import '../../../objectbox.g.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final categories = GetIt.I<Store>()
        .box<AssetCategory>()
        .getAll()
        .where((cat) => cat.getValue() > 0)
        .toList();

    categories.sort((a, b) => b.getValue().compareTo(a.getValue()));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              Text(
                "Your allocation",
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.s),
              AllocationPieChart(categories
                  .map((cat) => PieChartData(
                      cat.name,
                      cat.getValue(),
                      double.parse((cat.getValue() /
                              NetWorthRepoImpl().getNetWorth() *
                              100)
                          .toStringAsFixed(1))))
                  .toList()),
              SizedBox(height: Dimensions.l),
              IconButton(
                  onPressed: () =>
                      context.push(FullAssetAllocationScreen.route),
                  icon: Row(children: [
                    Text(
                      "See full asset allocation",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(decoration: TextDecoration.underline),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
