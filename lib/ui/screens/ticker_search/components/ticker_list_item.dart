import 'package:flutter/material.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';

class TickerListItem extends StatelessWidget {
  MarketInfo info;
  Function(MarketInfo) onTap;

  TickerListItem(this.info, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onTap(info),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    info.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  info.symbol,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  info.type,
                ),
                const Expanded(child: SizedBox()),
                Text(
                  "${info.currency} - ${info.region}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
