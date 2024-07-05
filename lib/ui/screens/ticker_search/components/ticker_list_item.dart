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
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (info.type != null) Text(info.type!)
              ],
            )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(info.symbol),
                  Text(
                    "${info.currency} - ${info.region ?? info.exchangeName}",
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
