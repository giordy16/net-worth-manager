import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:net_worth_manager/data/MarketPosition.dart';
import 'package:net_worth_manager/utils/extensions/NumberExtension.dart';

import '../../utils/TextStyles.dart';

class MarketPositionListItem extends StatelessWidget {
  MarketPosition position;
  bool isLast;

  MarketPositionListItem(this.position, {super.key, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    position.product.name,
                    style: normalTextTextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(width: 4),
                Text(position.getCurrentValue().formatted(), style: subTitleTextStyle())
              ],
            ),
            SizedBox(height: 4),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(position.product.ticker, style: smallTextTextStyle()),
                  Text(
                      ("${position.getDeltaPerc().formattedPerc()}%"),
                      style: smallTextTextStyle()),
                ]),
            Visibility(
                visible: !isLast,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(height: 1, width: double.infinity, color: Colors.grey)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
