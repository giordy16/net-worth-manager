import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_bloc.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_events.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_state.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_bottom_fab.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_selector_field.dart';
import 'package:path/path.dart';

import '../../widgets/base_components/app_text_field.dart';

class AddAssetCategory extends StatelessWidget {
  AddAssetCategory({super.key});

  static const route = "/AddAssetCategory";

  String categoryName = "";

  void saveCategory(BuildContext context) {
    objectbox.store.box<AssetCategory>().put(AssetCategory(categoryName));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add category"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AppBottomFab(
          text: "Save",
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
                  child: Text("Create a new category for your assets, for example \"Liquidity\", \"Passivity\", ...")
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.m),
                  child: AppTextField(
                    title: "Name",
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
