import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/ui/screens/add_selection/add_selection_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_screen.dart';
import 'package:net_worth_manager/ui/screens/sell_position/sell_position_cubit.dart';
import 'package:net_worth_manager/ui/screens/sell_position/sell_position_state.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_date_field.dart';
import 'package:net_worth_manager/utils/extensions/context_extensions.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../models/obox/asset_obox.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/base_components/app_numeric_text_field.dart';
import '../../widgets/base_components/app_selector_field.dart';
import '../../widgets/modal/user_message.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';

class SellPositionScreen extends StatelessWidget {
  static String path = "/SellPositionScreen";

  AddAssetPositionScreenParams params;

  SellPositionScreen(this.params);

  final formKey = GlobalKey<FormState>();

  Future<void> onAssetSelected(BuildContext context, Asset asset) async {
    if (asset == AddSelectionScreen.addNewAsset) {
      await context.push(AddSelectionScreen.route);
      context.read<SellPositionCubit>().initPage();
    } else {
      context.read<SellPositionCubit>().onAssetSelected(asset);
    }
  }

  Future<void> onAssetTaxSelected(BuildContext context, Asset asset) async {
    if (asset == AddSelectionScreen.addNewAsset) {
      await context.push(AddSelectionScreen.route);
      context.read<SellPositionCubit>().initPage();
    } else {
      context.read<SellPositionCubit>().onTaxAssetSelected(asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AssetRepoImpl>(create: (context) => AssetRepoImpl())
      ],
      child: BlocProvider<SellPositionCubit>(
          create: (context) => SellPositionCubit(
                asset: params.asset,
                position: params.timeValue!,
                assetRepo: context.read<AssetRepoImpl>(),
              ),
          child: BlocBuilder<SellPositionCubit, SellPositionState>(
            builder: (context, state) {
              final theme = Theme.of(context);

              return Scaffold(
                  appBar: AppBar(
                    title: Text("Sell position"),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: AppBottomFab(
                    text:
                        "Confirm sell (${state.positionGrossValue.toStringWithCurrency()})",
                    enable: state.quantityToSell! <= state.position.quantity,
                    onTap: () {
                      if (state.quantityToSell! <= state.position.quantity &&
                          formKey.currentState!.validate()) {
                        context.read<SellPositionCubit>().sell();

                        // back to asset detail
                        UserMessage.showMessage(context, "Position sold!");
                        context.popUntilPath(AssetDetailScreen.route);
                      }
                    },
                  ),
                  body: Form(
                    key: formKey,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.screenMargin),
                        child: ListView(
                          children: [
                            SizedBox(height: Dimensions.s),
                            AppDateField(
                              title: "Sell date",
                              isMandatory: true,
                              initialValue: state.sellDate,
                              onDatePicked: (date) {
                                context
                                    .read<SellPositionCubit>()
                                    .onSellDateChange(date);
                              },
                            ),
                            SizedBox(height: Dimensions.m),
                            AppNumericTextField(
                              moneyBehavior: false,
                              title:
                                  "Quantity to sell (max ${state.position.quantity.toStringFormatted()})",
                              initialValue: state.quantityToSell,
                              isMandatory: true,
                              onTextChange: (value) {
                                var qt = double.tryParse(value);
                                if (qt != null) {
                                  context
                                      .read<SellPositionCubit>()
                                      .onQuantityChange(qt);
                                }
                              },
                            ),
                            SizedBox(height: Dimensions.s),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Add position value to an other asset?",
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                )),
                                Checkbox(
                                    value: state.shouldMoveToAsset,
                                    onChanged: (value) {
                                      context
                                          .read<SellPositionCubit>()
                                          .onMoveAssetChange(value!);
                                    })
                              ],
                            ),
                            if (state.shouldMoveToAsset) ...[
                              Text(
                                  "You can select to which asset the value of the position should be added, for example a bank account."),
                              SizedBox(height: Dimensions.s),
                              AppSelectorField<Asset>(
                                title: "Asset",
                                initialValue: state.selectedAsset,
                                values: [
                                  ...state.selectableAssets,
                                  ...[AddSelectionScreen.addNewAsset]
                                ],
                                onItemSelected: (value) =>
                                    onAssetSelected(context, value),
                                isMandatory: true,
                              ),
                              SizedBox(height: Dimensions.m),
                            ],
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Apply tax?",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold))),
                                Checkbox(
                                    value: state.shouldApplyTax,
                                    onChanged: (value) {
                                      context
                                          .read<SellPositionCubit>()
                                          .onApplyTaxChange(value!);
                                    })
                              ],
                            ),
                            if (state.shouldApplyTax) ...[
                              Text(
                                  "Enter the tax percentage you will pay based on your contry."),
                              SizedBox(height: Dimensions.s),
                              AppNumericTextField(
                                title: "Tax (%)",
                                initialValue: state.taxPercentage,
                                moneyBehavior: false,
                                isMandatory: true,
                                onTextChange: (value) {
                                  var tax = double.tryParse(value);
                                  if (tax != null) {
                                    context
                                        .read<SellPositionCubit>()
                                        .onTaxChange(tax);
                                  }
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          "Add tax value to a liability?",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                  Checkbox(
                                      value: state.shouldAddTaxToAsset,
                                      onChanged: (value) {
                                        context
                                            .read<SellPositionCubit>()
                                            .onAddTaxToAsset(value!);
                                      })
                                ],
                              ),
                              if (state.shouldAddTaxToAsset) ...[
                                AppSelectorField<Asset>(
                                  title: "Asset",
                                  isMandatory: true,
                                  initialValue: state.selectedTaxAsset,
                                  values: [
                                    ...state.selectableAssets,
                                    ...[AddSelectionScreen.addNewAsset]
                                  ],
                                  onItemSelected: (value) =>
                                      onAssetTaxSelected(context, value),
                                ),
                              ]
                            ],
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          )),
    );
  }
}
