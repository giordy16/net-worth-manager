import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/ui/screens/add_category/add_category_screen.dart';
import 'package:net_worth_manager/ui/screens/home/components/home_page_asset.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import '../../../../models/obox/asset_obox.dart';
import '../../../widgets/modal/bottom_sheet.dart';

class HomePageCategory extends StatelessWidget {
  AssetCategory category;
  List<Asset> assets;
  Function(Asset) onItemClick;
  Function(Asset) onLongPress;
  Function(AssetCategory) onMoreClick;

  HomePageCategory({
    required this.category,
    required this.assets,
    required this.onItemClick,
    required this.onLongPress,
    required this.onMoreClick,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    double categoryTotalValue = 0;
    for (var asset in assets) {
      categoryTotalValue = categoryTotalValue + asset.getCurrentValue();
    }
    categoryTotalValue = double.parse(categoryTotalValue.toStringAsFixed(2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              category.name,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            IconButton(
                onPressed: () => onMoreClick(category),
                icon: const Icon(Icons.more_vert))
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var asset = assets[index];
            return HomePageAsset(
              asset,
              (asset) => onItemClick(asset),
              (asset) => onLongPress(asset),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 1);
          },
          itemCount: assets.length,
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.m),
          child: Row(
            children: [
              Text("Total",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              const Expanded(child: SizedBox()),
              Text(
                categoryTotalValue.toStringWithCurrency(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
