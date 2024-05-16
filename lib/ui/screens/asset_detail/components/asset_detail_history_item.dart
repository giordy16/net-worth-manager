import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../../main.dart';
import '../../../../models/obox/asset_obox.dart';
import '../../../../models/obox/settings_obox.dart';
import '../asset_detail_bloc.dart';
import '../asset_detail_event.dart';

class AssetDetailHistoryItem extends StatelessWidget {
  Asset asset;
  AssetTimeValue timeValue;

  DateFormat df = DateFormat("dd/MM/yyyy");

  AssetDetailHistoryItem(
      {super.key, required this.asset, required this.timeValue});

  @override
  Widget build(BuildContext context) {
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
          child: asset.marketInfo.target == null
              ? buildSimpleAssetItem()
              : buildMarketAssetItem()),
    );
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

  Widget buildMarketAssetItem() {
    String mainCurrency = objectbox.store
        .box<Settings>()
        .getAll()
        .first
        .defaultCurrency
        .target!
        .name;

    double value =
        timeValue.quantity * asset.marketInfo.target!.getValueAtMainCurrency();

    double performance = double.parse((asset.marketInfo.target!.value -
        (timeValue.quantity * timeValue.quantity)).toStringAsFixed(2));

    return Row(
      children: [
        Text(df.format(timeValue.date)),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                "Prezzo di acquisto: ${timeValue.getPurchaseValueWithPurchaseCurrency()}"),
            Text("Valore attuale: $mainCurrency ${value.toStringFormatted()}"),
            Text("Utili: ${performance.toStringFormatted()}")
          ],
        ),
      ],
    );
  }
}
