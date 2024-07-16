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

import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../widgets/base_components/app_text_field.dart';

class AddAssetScreen extends StatelessWidget {
  AddAssetScreen({super.key, this.asset});

  static const route = "/AddAssetScreen";

  final _formKey = GlobalKey<FormState>();

  Asset? asset;

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
    if (asset != null) {
      // edit asset
      context.read<AddAssetBloc>().add(SaveAssetEvent(asset: asset));
      return;
    }

    bool? yes = await showYesNoBottomSheet(context, t.add_position_question);

    if (yes == null) return;

    if (yes) {
      context.read<AddAssetBloc>().add(SaveAssetAndOpenPositionEvent());
    } else {
      context.read<AddAssetBloc>().add(SaveAssetEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AssetRepoImpl(),
      child: BlocProvider(
          create: (context) => AddAssetBloc(
                assetRepo: context.read<AssetRepoImpl>(),
                context: context,
              )
                ..add(FetchAddAssetData())
                ..add(SetInitialValue(asset)),
          child: BlocBuilder<AddAssetBloc, AddAssetState>(
              builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(t.asset_liability),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: AppBottomFab(
                  text: t.save,
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
                              child: Text(t.add_asset_subtitle)),
                          Padding(
                            padding: const EdgeInsets.only(top: Dimensions.m),
                            child: AppTextField(
                              initialValue: state.assetName,
                              title: t.name,
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
                              title: t.category,
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
                          Padding(
                              padding: const EdgeInsets.only(top: Dimensions.l),
                              child: Text(
                                t.add_asset_disclaimer,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                              )),
                        ],
                      ),
                    ),
                  ),
                ));
          })),
    );
  }
}
