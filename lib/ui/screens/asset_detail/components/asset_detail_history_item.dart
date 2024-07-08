import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../../app_dimensions.dart';
import '../../../../models/obox/asset_obox.dart';
import '../../../../models/obox/settings_obox.dart';
import '../../../widgets/base_components/performance_text.dart';
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
    bool shouldShowOriginalPrice = timeValue.currency.target!.name !=
        GetIt.I<Settings>().defaultCurrency.target!.name;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.m),
          child: Row(
            children: [
              Text(df.format(timeValue.date)),
              const Expanded(child: SizedBox()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timeValue
                      .getTotalPurchaseValue()
                      .atMainCurrency(
                          fromCurrency: timeValue.currency.target!.name)
                      .toStringWithCurrency()),
                  if (shouldShowOriginalPrice)
                    Text(
                        "(${timeValue.getTotalPurchaseValue().toStringFormatted()} ${timeValue.currency.target!.symbol})")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMarketAssetItem(BuildContext context) {
    double performance =
        timeValue.getPerformance(asset.marketInfo.target!.symbol);
    double performancePerc =
        timeValue.getPerformancePerc(asset.marketInfo.target!.symbol);
    final theme = Theme.of(context);

    return Material(
      child: InkWell(
        onTap: () async {
          await context.push(AddAssetPositionScreen.route,
              extra: AddAssetPositionScreenParams(
                asset: asset,
                timeValue: timeValue,
                showSellButton: true
              ));
          context.read<AssetDetailBloc>().add(FetchGraphDataEvent());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.m),
          child: Row(
            children: [
              Text("${df.format(timeValue.date)}"),
              const Expanded(child: SizedBox()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timeValue
                      .getCurrentValue(marketInfo: asset.marketInfo.target)
                      .toStringWithCurrency()),
                  Row(
                    children: [
                      PerformanceText(
                        performance: performance,
                        type: PerformanceTextType.value,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      PerformanceText(
                        performance: performancePerc,
                        type: PerformanceTextType.percentage,
                        textStyle: theme.textTheme.bodyMedium,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
