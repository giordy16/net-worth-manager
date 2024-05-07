import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/ui/screens/home/components/home_page_asset.dart';

import '../../../../main.dart';
import '../../../../models/obox/asset_obox.dart';

class HomePageCategory extends StatelessWidget {
  AssetCategory category;
  List<Asset> assets;
  Function(Asset) onItemClick;

  HomePageCategory({
    required this.category,
    required this.assets,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Dimensions.xxs),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var asset = assets[index];
              return HomePageAsset(asset, (asset) => onItemClick(asset));
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: assets.length)
      ],
    );
  }
}
