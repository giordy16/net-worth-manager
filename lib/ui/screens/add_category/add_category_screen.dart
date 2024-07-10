import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_bottom_fab.dart';

import '../../../i18n/strings.g.dart';
import '../../../objectbox.g.dart';
import '../../widgets/base_components/app_text_field.dart';

class AddAssetCategory extends StatelessWidget {
  AddAssetCategory({super.key, this.category});

  static const route = "/AddAssetCategory";

  AssetCategory? category;

  String categoryName = "";

  void saveCategory(BuildContext context) {
    if (category != null) {
      // edit category
      category?.name = categoryName;
      GetIt.I<Store>().box<AssetCategory>().put(category!);
    } else {
      // new category
      GetIt.I<Store>().box<AssetCategory>().put(AssetCategory(categoryName));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(t.add_category),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AppBottomFab(
          text: t.save,
          onTap: () => saveCategory(context),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: Dimensions.xs),
                    child: Text(t.add_category_message)),
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.m),
                  child: AppTextField(
                    initialValue: category?.name,
                    title: t.name,
                    onTextChange: (value) {
                      categoryName = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
