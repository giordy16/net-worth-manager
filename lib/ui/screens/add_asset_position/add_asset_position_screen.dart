import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_bloc.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_date_field.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_money_field.dart';

import '../../../app_dimensions.dart';
import '../../../domain/repository/asset/asset_repo_impl.dart';
import '../../../models/obox/asset_time_value_obox.dart';
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/base_components/app_text_field.dart';
import '../../widgets/modal/bottom_sheet.dart';
import 'add_asset_position_screen_params.dart';
import 'add_position_state.dart';

class AddAssetPositionScreen extends StatelessWidget {
  static const route = "/AddAssetPositionScreen";

  AddAssetPositionScreenParams params;

  AddAssetPositionScreen({super.key, required this.params});

  final _formKey = GlobalKey<FormState>();

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
                  assetRepo: context.read<AssetRepoImpl>(),
                )..add(InitState(params.timeValue)),
            child: BlocBuilder<AddPositionBloc, AddPositionState>(
                builder: (context, state) {
              return Scaffold(
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
                            .add(SavePositionEvent(params));
                        context.pop();
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
                                initialValue: state.dateTime,
                                title: "Date",
                                isMandatory: true,
                                onDatePicked: (date) {
                                  context
                                      .read<AddPositionBloc>()
                                      .add(ChangeDateEvent(date));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.m),
                              child: AppMoneyField(
                                title: "Value",
                                initialValue: state.cost,
                                isMandatory: true,
                                onTextChange: (value) {
                                  context.read<AddPositionBloc>().add(
                                      ChangeCostEvent(double.tryParse(value)));
                                },
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
