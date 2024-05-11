import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/components/asset_detail_history_item.dart';

import '../../../models/obox/asset_obox.dart';
import '../../widgets/graph/asset_line_graph.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';

class AssetDetailScreen extends StatelessWidget {
  static const route = "/AssetDetailScreen";

  Asset asset;

  AssetDetailScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Current value:"),
                Text(
                  asset.getLastValueWithCurrency(),
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: Dimensions.l),
                AssetLineGraph(
                  asset: asset,
                ),
                const SizedBox(height: Dimensions.l),
                Row(
                  children: [
                    Text(
                      "History",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          context.push(
                            AddAssetPositionScreen.route,
                            extra: AddAssetPositionScreenParams(asset: asset),
                          );
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                const SizedBox(height: Dimensions.m),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var timeValue = asset.getTimeValuesChronologicalOrder(
                          latestFirst: true)[index];
                      return AssetDetailHistoryItem(
                        asset: asset,
                        timeValue: timeValue,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: asset.timeValues.length)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
