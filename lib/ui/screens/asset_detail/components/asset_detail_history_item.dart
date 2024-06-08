import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'package:net_worth_manager/ui/widgets/base_components/performance_box.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../../app_dimensions.dart';
import '../../../../main.dart';
import '../../../../models/obox/asset_obox.dart';
import '../../../../models/obox/settings_obox.dart';
import '../asset_detail_bloc.dart';
import '../asset_detail_event.dart';

class AssetDetailHistoryItem extends StatelessWidget {
  Asset asset;
  AssetTimeValue timeValue;

  AssetDetailHistoryItem(this.asset, this.timeValue);

  DateFormat df = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return asset.marketInfo.target == null
        ? buildSimpleAssetItem(context)
        : buildMarketAssetItem(context);
  }

  Widget buildSimpleAssetItem(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Material(
      child: InkWell(
        onTap: () async {
          await context.push(AddAssetPositionScreen.route,
              extra: AddAssetPositionScreenParams(
                asset: asset,
                timeValue: timeValue,
              ));
          context.read<AssetDetailBloc>().add(FetchGraphDataEvent());
        },
        child: Row(
          children: [
            Text(df.format(timeValue.date)),
            const Expanded(child: SizedBox()),
            Text(timeValue.getTotalPurchaseValue().atMainCurrency(fromCurrency: timeValue.currency.target!.name).toStringWithCurrency()),
          ],
        ),
      ),
    );
  }

  Widget buildMarketAssetItem(BuildContext context) {
    double performance =
        timeValue.getPerformance(asset.marketInfo.target!.symbol);
    double performancePerc =
        timeValue.getPerformancePerc(asset.marketInfo.target!.symbol);

    return Material(
      child: InkWell(
        onTap: () async {
          await context.push(AddAssetPositionScreen.route,
              extra: AddAssetPositionScreenParams(
                asset: asset,
                timeValue: timeValue,
              ));
          context.read<AssetDetailBloc>().add(FetchGraphDataEvent());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Purchase date: ${df.format(timeValue.date)}"),
            const SizedBox(height: Dimensions.xs),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quantity: ${timeValue.quantity.toStringFormatted()}"),
                    Text(
                        "Purchase price: ${timeValue.value.toStringWithCurrency()}"),
                  ],
                ),
                const Expanded(child: SizedBox()),
                PerformanceBox(
                  currentValue: timeValue
                      .getCurrentValue(marketInfo: asset.marketInfo.target)
                      .toStringWithCurrency(),
                  performance: performance,
                  performancePerc: performancePerc,
                  showType: PerformanceShowType.column,
                )

                // IconButton(
                //     onPressed: () async {
                //       await context.push(AddAssetPositionScreen.route,
                //           extra: AddAssetPositionScreenParams(
                //             asset: asset,
                //             timeValue: timeValue,
                //           ));
                //       context.read<AssetDetailBloc>().add(FetchGraphDataEvent());
                //     },
                //     icon: Icon(
                //       Icons.edit,
                //       color: theme.colorScheme.secondary,
                //     )),
                // IconButton(
                //     onPressed: () async {},
                //     icon: Icon(
                //       Icons.sell_outlined,
                //       color: theme.colorScheme.secondary,
                //     )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
