import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import '../../../../main.dart';
import '../../../../models/obox/asset_obox.dart';
import '../../../../models/obox/settings_obox.dart';

class HomePageAsset extends StatelessWidget {
  Asset asset;
  Function(Asset) onItemClick;
  Function(Asset) onLongPress;

  HomePageAsset(this.asset, this.onItemClick, this.onLongPress);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Settings settings = objectbox.store.box<Settings>().getAll().first;
    DateFormat df = DateFormat("dd/MM/yyyy");

    return Material(
      child: InkWell(
        onTap: () => onItemClick(asset),
        onLongPress: () => onLongPress(asset),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: theme.textTheme.bodyLarge),
                Visibility(
                  visible: asset.marketInfo.target == null,
                  child: Text(
                      "Last update: ${asset.getLastUpdateDate() != null ? df.format(asset.getLastUpdateDate()!) : "-"}",
                      style: theme.textTheme.bodySmall),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Text(
              asset.getCurrentValue().toStringWithCurrency(),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
