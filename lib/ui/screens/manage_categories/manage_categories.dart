import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../objectbox.g.dart';
import '../add_category/add_category_screen.dart';

class ManageCategories extends StatefulWidget {
  static String path = "/ManageCategories";

  @override
  State<StatefulWidget> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  Future<void> onShowMoreCategory(AssetCategory category) async {
    Map<Widget, Function> selections = {};

    selections.addAll({
      const Row(
        children: [
          Icon(Icons.edit),
          SizedBox(
            width: 4,
          ),
          Text("Edit name")
        ],
      ): () async {
        await context.push(AddAssetCategory.route, extra: category);
        setState(() {});
        ScaffoldWithBottomNavigation.updateScreens();
      }
    });

    selections.addAll({
      const Row(
        children: [
          Icon(Icons.delete_outlined),
          SizedBox(
            width: 4,
          ),
          Text("Delete")
        ],
      ): () async {
        if (category.getAssets().isEmpty) {
          if ((await showDeleteConfirmSheet(context,
                  "Are you sure you want to delete this category?\nAll its asset and positions will be deleted.")) ==
              true) {
            GetIt.I<Store>().box<AssetCategory>().remove(category.id);
            setState(() {});
            ScaffoldWithBottomNavigation.updateScreens();
          }
        } else {
          showOkOnlyBottomSheet(context,
              "This category has some assets under it. Only empty categories can be removed. Please, remove the assets from the Home.");
        }
      }
    });

    var selectedOption =
        await showSelectionSheet(context, selections.keys.toList());
    selections[selectedOption]?.call();
  }

  @override
  Widget build(BuildContext context) {
    final categories = GetIt.I<Store>()
        .box<AssetCategory>()
        .query(AssetCategory_.userCanSelect.equals(true))
        .build()
        .find();

    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: SafeArea(
        child: categories.isEmpty
            ? Center(child: Text("You don't have any categories"))
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return IconButton(
                      onPressed: () => onShowMoreCategory(categories[index]),
                      icon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.screenMargin,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              categories[index].name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                            SizedBox(width: Dimensions.s),
                            Icon(Icons.more_vert)
                          ],
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin), child: AppDivider());
                },
                itemCount: categories.length,
              ),
      ),
    );
  }
}
