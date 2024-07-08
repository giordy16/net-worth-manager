import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import '../../../../app_dimensions.dart';
import '../../../../models/obox/asset_obox.dart';

class HomePageAsset extends StatelessWidget {
  Asset asset;
  Function(Asset) onItemClick;
  Function(Asset) onLongPress;

  HomePageAsset(this.asset, this.onItemClick, this.onLongPress);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DateFormat df = DateFormat("dd/MM/yyyy");

    return Material(
      child: InkWell(
        onTap: () => onItemClick(asset),
        onLongPress: () => onLongPress(asset),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.m),
          child: Row(
            children: [
              Expanded(child: Text(asset.name, style: theme.textTheme.bodyLarge)),
              const SizedBox(width: Dimensions.s),
              Text(
                asset.getCurrentValue().toStringWithCurrency(),
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
