import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_worth_manager/ui/investments/AddTransactionPage.dart';

import '../../data/ProductEntity.dart';
import '../../utils/TextStyles.dart';

class SearchMarketWidget extends StatelessWidget {
  ProductEntity product;

  SearchMarketWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.to(() => AddTransactionPage(product));
      },
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
                    product.name,
                    style: normalTextTS(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 4),
                Text(product.ticker, style: subTitleTS())
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(product.type, style: smallTextTS()),
                ),
                SizedBox(width: 4),
                Text("${product.exchange ?? " "} - ${product.country ?? " "}",
                    style: smallTextTS())
              ],
            ),
            SizedBox(height: 16),
            Container(height: 1, width: double.infinity, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
