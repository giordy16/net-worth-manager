import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
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
        ? buildSimpleAssetItem()
        : buildMarketAssetItem(context);
  }

  Widget buildSimpleAssetItem() {
    return Row(
      children: [
        Text(df.format(timeValue.date)),
        const Expanded(child: SizedBox()),
        Text(timeValue.getCurrentValueWithMainCurrency()),
      ],
    );
  }

  Widget buildMarketAssetItem(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Currency mainCurrency =
    objectbox.store.box<Settings>().getAll().first.defaultCurrency.target!;

    Currency assetCurrency = asset.marketInfo.target!.getCurrency();

    double value = double.parse((timeValue.quantity *
        asset.marketInfo.target!.getCurrentValueAtMainCurrency())
        .toStringAsFixed(2));

    double performance =
    timeValue.getPerformance(asset.marketInfo.target!.value);
    double performancePerc = timeValue
        .getPerformancePerc(asset.marketInfo.target!.value);
    String performanceWithSign = performance >= 0
        ? "+${performance.toStringFormatted()}"
        : performance.toStringFormatted();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(df.format(timeValue.date)),
                SizedBox(height: Dimensions.xs,),
                Row(
                  children: [
                    Text("Utili: "),
                    Text(
                      "$performanceWithSign${assetCurrency.symbol}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: performance >= 0 ? Colors.green : Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$performancePerc%",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: performance >= 0 ? Colors.green : Colors.red),
                    )
                  ],
                ),
                Text(
                    "Valore attuale: ${mainCurrency.symbol} ${value.toStringFormatted()}"),
                Text(
                    "Quantità: ${timeValue.quantity.toStringFormatted()}"),
                Text(
                    "Prezzo di acquisto: ${timeValue.getPurchaseValueWithPurchaseCurrency()}"),
              ],
            ),
            const Expanded(child: SizedBox()),
            IconButton(
                onPressed: () async {
                  await context.push(AddAssetPositionScreen.route,
                      extra: AddAssetPositionScreenParams(
                        asset: asset,
                        timeValue: timeValue,
                      ));
                  context.read<AssetDetailBloc>().add(FetchGraphDataEvent());

                },
                icon: Icon(
                  Icons.edit,
                  color: theme.colorScheme.secondary,
                )),
          ],
        ),
      ],
    );
  }
  
}
