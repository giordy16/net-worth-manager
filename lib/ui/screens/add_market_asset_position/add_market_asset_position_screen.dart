import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_date_field.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_numeric_text_field.dart';
import 'package:net_worth_manager/utils/extensions/string_extension.dart';

import '../../../app_dimensions.dart';
import '../../../models/obox/asset_obox.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/base_components/app_text_field.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';

class AddMarketAssetPositionScreen extends StatelessWidget {
  static const route = "/AddMarketAssetPositionScreen";

  AddAssetPositionScreenParams params;

  late DateTime positionTime;
  late double? positionValue;
  late double? positionQuantity;

  AddMarketAssetPositionScreen({super.key, required this.params});

  final _formKey = GlobalKey<FormState>();

  void onSave(BuildContext context) {
    params.timeValue ??= AssetTimeValue.empty();

    params.timeValue!.date = positionTime;
    params.timeValue!.value = positionValue!;
    params.timeValue!.quantity = positionQuantity!;

    context.pop(params.timeValue);
  }

  @override
  Widget build(BuildContext context) {
    positionTime = params.timeValue?.date ?? DateTime.now();
    positionValue = params.timeValue?.value;
    positionQuantity = params.timeValue?.quantity;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Position"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AppBottomFab(
          text: "Save",
          onTap: () {
            if (_formKey.currentState!.validate()) {
              onSave(context);
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
                    padding: const EdgeInsets.only(top: Dimensions.m),
                    child: AppTextField(
                      initialValue: params.asset.name,
                      title: "Asset",
                      readOnly: true,
                      isMandatory: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.m),
                    child: AppDateField(
                      initialValue: positionTime,
                      title: "Date",
                      isMandatory: true,
                      onDatePicked: (date) {
                        positionTime = date;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.m),
                    child: AppNumericTextField(
                      moneyBehavior: true,
                      title: "Value",
                      initialValue: positionValue,
                      isMandatory: true,
                      onTextChange: (value) {
                        positionValue = value.convertToDouble();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Dimensions.m),
                    child: AppNumericTextField(
                        title: "Quantity",
                        initialValue: positionQuantity,
                        isMandatory: true,
                        onTextChange: (value) {
                          positionQuantity = value.convertToDouble();
                        },
                        moneyBehavior: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
