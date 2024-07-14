import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_bottom_fab.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';

import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_category_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/modal/user_message.dart';
import '../add_category/add_category_screen.dart';

enum ManageCategoriesViewType { normal, reorder }

class ManageCategories extends StatefulWidget {
  static String path = "/ManageCategories";

  ManageCategoriesViewType? viewType;

  ManageCategories(this.viewType);

  @override
  State<StatefulWidget> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  late ManageCategoriesViewType viewType;
  late List<AssetCategory> categories;

  void loadCategories() {
    categories = GetIt.I<Store>()
        .box<AssetCategory>()
        .query()
        .order(AssetCategory_.order)
        .build()
        .find();
  }

  @override
  void initState() {
    viewType = widget.viewType ?? ManageCategoriesViewType.normal;
    loadCategories();

    super.initState();
  }

  Future<void> onShowMoreCategory(AssetCategory category) async {
    Map<Widget, Function> selections = {};

    selections.addAll({
      Row(
        children: [
          Icon(Icons.edit),
          SizedBox(
            width: 4,
          ),
          Text(t.edit_name)
        ],
      ): () async {
        await context.push(AddAssetCategory.route, extra: category);
        setState(() {});
        ScaffoldWithBottomNavigation.updateScreens();
      }
    });

    if (category.userCanSelect) {
      selections.addAll({
        Row(
          children: [
            Icon(Icons.delete_outlined),
            SizedBox(
              width: 4,
            ),
            Text(t.delete)
          ],
        ): () async {
          if (category.getAssets().isEmpty) {
            if ((await showDeleteConfirmSheet(
                    context, t.delete_confirmation_category_short)) ==
                true) {
              GetIt.I<Store>().box<AssetCategory>().remove(category.id);
              setState(() {});
              ScaffoldWithBottomNavigation.updateScreens();
              UserMessage.showMessage(context, t.deleted);
            }
          } else {
            showOkOnlyBottomSheet(context, t.delete_cat_error);
          }
        }
      });
    }

    var selectedOption =
        await showSelectionSheet(context, selections.keys.toList());
    selections[selectedOption]?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.categories),
        actions: [
          IconButton(
              onPressed: () {
                if (viewType == ManageCategoriesViewType.normal) {
                  viewType = ManageCategoriesViewType.reorder;
                } else {
                  viewType = ManageCategoriesViewType.normal;
                }
                setState(() {});
              },
              icon: Icon(Icons.swap_vert)),
          if (viewType == ManageCategoriesViewType.normal)
            IconButton(
                onPressed: () async {
                  await context.push(AddAssetCategory.route);
                  setState(() {
                    loadCategories();
                  });
                },
                icon: Icon(Icons.add))
        ],
      ),
      body: SafeArea(
          child: categories.isEmpty
              ? Center(child: Text(t.empty_categories))
              : viewType == ManageCategoriesViewType.normal
                  ? buildNormalView(context)
                  : buildReorderView(context)),
    );
  }

  Widget buildNormalView(BuildContext context) {
    return ListView.separated(
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
            padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
            child: AppDivider());
      },
      itemCount: categories.length,
    );
  }

  Widget buildReorderView(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ReorderableListView(
              onReorder: onReorder,
              children: categories.map((c) {
                return Padding(
                  key: Key(c.hashCode.toString()),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.screenMargin,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              c.name,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                            SizedBox(width: Dimensions.s),
                            Icon(Icons.drag_handle)
                          ],
                        ),
                      ),
                      if (categories.indexOf(c) != categories.length - 1)
                        AppDivider()
                    ],
                  ),
                );
              }).toList())),
      AppBottomFab(text: t.confirm_order, onTap: confirmOrder)
    ]);
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      var item = categories.removeAt(oldIndex);
      categories.insert(newIndex, item);
    });
  }

  void confirmOrder() {
    for (int i = 0; i < categories.length; i++) {
      categories[i].order = i;
    }
    GetIt.I<Store>().box<AssetCategory>().putMany(categories);
    UserMessage.showMessage(context, t.done);
    ScaffoldWithBottomNavigation.updateScreens();
    context.pop();
  }
}
