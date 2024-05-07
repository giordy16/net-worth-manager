import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

class AssetDetailHistoryItem extends StatelessWidget {
  AssetTimeValue timeValue;

  AssetDetailHistoryItem({super.key, required this.timeValue});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DateFormat df = DateFormat("dd/MM/yyyy");

    return Material(
      child: InkWell(
        // onTap: () => onItemClick(asset),
        child: Row(
          children: [
            Text(df.format(timeValue.date)),
            const Expanded(child: SizedBox()),
            Text(timeValue.getLastValueWithCurrency()),
          ],
        ),
      ),
    );
  }
}
