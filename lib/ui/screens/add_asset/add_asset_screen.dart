import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_bloc.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_events.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_state.dart';
import 'package:net_worth_manager/ui/screens/add_category/add_category_screen.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_bottom_fab.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_selector_field.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';

import '../../widgets/base_components/app_text_field.dart';

class AddAssetScreen extends StatelessWidget {
  AddAssetScreen({super.key});

  static const route = "/AddAssetScreen";

  final _formKey = GlobalKey<FormState>();

  Future<void> onCategorySelected(
    BuildContext context,
    AssetCategory category,
  ) async {
    if (category == AppSelectorField.addNewCategory) {
      await context.push(AddAssetCategory.route);
      context.read<AddAssetBloc>().add(FetchAddAssetData());
    } else {
      context.read<AddAssetBloc>().add(ChangeCategoryEvent(category));
    }
  }

  Future<void> saveAsset(BuildContext context) async {
    bool? yes = await showYesNoBottomSheet(
        context, "Do you want to add a position for this asset?");

    if (yes == null) return;

    if (yes) {
      // todo open add position
      print("YES");
    } else {
      context.read<AddAssetBloc>().add(SaveAssetEvent());
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AssetRepoImpl(),
      child: BlocProvider(
          create: (context) => AddAssetBloc(
                assetRepo: context.read<AssetRepoImpl>(),
              )..add(FetchAddAssetData()),
          child: BlocBuilder<AddAssetBloc, AddAssetState>(
              builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Add asset"),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: AppBottomFab(
                  text: "Save",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      saveAsset(context);
                    }
                  },
                ),
                body: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.screenMargin),
                      child: Column(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: Dimensions.xs),
                              child: Text(
                                  "Create a new assets. After you save it, you can add your position.")),
                          Padding(
                            padding: const EdgeInsets.only(top: Dimensions.m),
                            child: AppTextField(
                              initialValue: state.assetName,
                              title: "Name",
                              onTextChange: (value) {
                                context
                                    .read<AddAssetBloc>()
                                    .add(ChangeNameEvent(value));
                              },
                              isMandatory: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: Dimensions.m),
                            child: AppSelectorField<AssetCategory>(
                              title: "Category",
                              initialValue: state.assetCategory,
                              values: [
                                ...state.assetCategorySelectable,
                                ...[AppSelectorField.addNewCategory]
                              ],
                              onItemSelected: (value) =>
                                  onCategorySelected(context, value),
                              isMandatory: true,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: Dimensions.m),
                          //   child: AppMoneyField(
                          //     title: "Value",
                          //     onTextChange: (value) {
                          //       context.read<AddAssetBloc>().add(ChangeValueEvent(
                          //           double.tryParse(value) ?? 0.0));
                          //     },
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: Dimensions.m),
                          //   child: AppDateField(
                          //     title: "Purchase date",
                          //     onDatePicked: (value) {},
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ));
          })),
    );
  }
}
