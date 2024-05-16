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

class AssetDetailHistoryItem extends StatefulWidget {
  Asset asset;
  AssetTimeValue timeValue;

  AssetDetailHistoryItem(this.asset, this.timeValue);

  @override
  State<StatefulWidget> createState() => _AssetDetailHistoryItemState();
}

class _AssetDetailHistoryItemState extends State<AssetDetailHistoryItem> {
  DateFormat df = DateFormat("dd/MM/yyyy");

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
          onTap: () async {
            await context.push(AddAssetPositionScreen.route,
                extra: AddAssetPositionScreenParams(
                  asset: widget.asset,
                  timeValue: widget.timeValue,
                ));
            context.read<AssetDetailBloc>().add(FetchGraphDataEvent());
          },
          child: widget.asset.marketInfo.target == null
              ? buildSimpleAssetItem()
              : buildMarketAssetItem(context)),
    );
  }

  Widget buildSimpleAssetItem() {
    return Row(
      children: [
        Text(df.format(widget.timeValue.date)),
        const Expanded(child: SizedBox()),
        Text(widget.timeValue.getCurrentValueWithMainCurrency()),
      ],
    );
  }

  Widget buildMarketAssetItem(BuildContext context) {
    Currency mainCurrency =
        objectbox.store.box<Settings>().getAll().first.defaultCurrency.target!;

    Currency assetCurrency = widget.asset.marketInfo.target!.getCurrency();

    double value = double.parse((widget.timeValue.quantity *
            widget.asset.marketInfo.target!.getCurrentValueAtMainCurrency())
        .toStringAsFixed(2));

    double performance =
        widget.timeValue.getPerformance(widget.asset.marketInfo.target!.value);
    double performancePerc = widget.timeValue
        .getPerformancePerc(widget.asset.marketInfo.target!.value);
    String performanceWithSign = performance >= 0
        ? "+${performance.toStringFormatted()}"
        : performance.toStringFormatted();

    return AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(df.format(widget.timeValue.date)),
              const Expanded(child: SizedBox()),
              Text(
                "${mainCurrency.symbol} ${value.toStringFormatted()}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  icon: expanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more))
            ],
          ),
          Visibility(
            visible: expanded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    "Quantità: ${widget.timeValue.quantity.toStringFormatted()}"),
                Text(
                    "Prezzo di acquisto: ${widget.timeValue.getPurchaseValueWithPurchaseCurrency()}"),
                const SizedBox(
                  height: Dimensions.m,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
