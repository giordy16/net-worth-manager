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

import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/base_components/app_numeric_text_field.dart';
import '../../widgets/base_components/app_selector_field.dart';
import '../../widgets/modal/user_message.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';

class SellPositionScreen extends StatelessWidget {
  static String path = "/SellPositionScreen";

  AddAssetPositionScreenParams params;

  SellPositionScreen(this.params, {super.key});

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
                    title: Text(t.sell_position),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: AppBottomFab(
                    text:
                        "${t.confirm_sell} (${state.positionGrossValue.toStringWithCurrency()})",
                    enable: state.quantityToSell! <= state.position.quantity,
                    onTap: () {
                      if (state.quantityToSell! <= state.position.quantity &&
                          formKey.currentState!.validate()) {
                        context.read<SellPositionCubit>().sell();

                        // back to asset detail
                        UserMessage.showMessage(context, t.position_sold);
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
                            const SizedBox(height: Dimensions.s),
                            AppDateField(
                              title: t.sell_date,
                              isMandatory: true,
                              initialValue: state.sellDate,
                              onDatePicked: (date) {
                                context
                                    .read<SellPositionCubit>()
                                    .onSellDateChange(date);
                              },
                            ),
                            const SizedBox(height: Dimensions.m),
                            AppNumericTextField(
                              moneyBehavior: false,
                              title: t.sell_quantity.replaceAll("<qt>",
                                  state.position.quantity.toStringFormatted()),
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
                            const SizedBox(height: Dimensions.s),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  t.sell_add_asset_value,
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
                              Text(t.sell_add_asset_value_message),
                              const SizedBox(height: Dimensions.s),
                              AppSelectorField<Asset>(
                                title: t.asset,
                                initialValue: state.selectedAsset,
                                values: [
                                  ...state.selectableAssets,
                                  ...[AddSelectionScreen.addNewAsset]
                                ],
                                onItemSelected: (value) =>
                                    onAssetSelected(context, value),
                                isMandatory: true,
                              ),
                              const SizedBox(height: Dimensions.m),
                            ],
                            Row(
                              children: [
                                Expanded(
                                    child: Text(t.sell_apply_tax,
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
                              Text(t.sell_apply_tax_message),
                              const SizedBox(height: Dimensions.s),
                              AppNumericTextField(
                                title: t.tax_placeholder,
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
                                      child: Text(t.sell_tax_add_liability,
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
                                  title: t.asset,
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
