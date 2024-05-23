import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_bloc.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_date_field.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_numeric_text_field.dart';
import 'package:net_worth_manager/utils/extensions/string_extension.dart';
import '../../../app_dimensions.dart';
import '../../../domain/repository/asset/asset_repo_impl.dart';
import '../../../models/obox/asset_time_value_obox.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/base_components/app_text_field.dart';
import '../../widgets/modal/bottom_sheet.dart';
import 'add_asset_position_screen_params.dart';
import 'add_position_state.dart';

class AddAssetPositionScreen extends StatefulWidget {
  static const route = "/AddAssetPositionScreen";

  AddAssetPositionScreenParams params;

  AddAssetPositionScreen({super.key, required this.params});

  @override
  State<StatefulWidget> createState() => _AddAssetPositionScreenState();

}

class _AddAssetPositionScreenState extends State<AddAssetPositionScreen> {

  final _formKey = GlobalKey<FormState>();

  late AddAssetPositionScreenParams params;
  late AssetTimeValue position;

  @override
  void initState(){

    params = widget.params;

    position = params.timeValue == null
        ? AssetTimeValue.empty(params.asset.marketInfo.target)
        : params.timeValue!.duplicate();

    super.initState();
  }

  Future<void> onDelete(BuildContext context) async {
    var yes = await showDeleteConfirmSheet(context);
    if (yes == true) {
      context
          .read<AddPositionBloc>()
          .add(DeletePositionEvent(params.asset, params.timeValue!));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    return RepositoryProvider(
        create: (_) => AssetRepoImpl(),
        child: BlocProvider(
            create: (context) => AddPositionBloc(
                  context: context,
                  assetRepo: context.read<AssetRepoImpl>(),
                ),
            child: BlocBuilder<AddPositionBloc, AddPositionState>(
                builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text("Position"),
                    actions: [
                      if (params.timeValue != null)
                        IconButton(
                          onPressed: () => onDelete(context),
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.white,
                          ),
                        )
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: AppBottomFab(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AddPositionBloc>()
                            .add(SavePositionEvent(params.asset, position));
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
                                initialValue: position.date,
                                title: "Date",
                                isMandatory: true,
                                onDatePicked: (date) {
                                  position.date = date;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.m),
                              child: AppNumericTextField(
                                moneyBehavior: true,
                                title: "Value",
                                initialValue: position.value,
                                currency: position.currency.target,
                                userCanChangeCurrency:
                                    params.asset.marketInfo.target == null,
                                isMandatory: true,
                                onTextChange: (value) {
                                  position.value = value.convertToDouble();
                                },
                                onCurrencyChange: (currency) {
                                  position.currency.target = currency;
                                },
                              ),
                            ),
                            Visibility(
                              // visible only for market asset
                              visible: params.asset.marketInfo.target != null,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: Dimensions.m),
                                child: AppNumericTextField(
                                  title: "Quantity",
                                  initialValue: position.quantity,
                                  isMandatory: true,
                                  onTextChange: (value) {
                                    position.quantity = value.convertToDouble();
                                  },
                                  moneyBehavior: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            })));
  }
}
