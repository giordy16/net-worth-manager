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
import '../../widgets/base_components/app_bottom_fab.dart';
import '../../widgets/base_components/app_text_field.dart';
import 'add_position_state.dart';

class AddAssetPositionScreen extends StatelessWidget {
  static const route = "/AddAssetPositionScreen";

  Asset asset;

  AddAssetPositionScreen({super.key, required this.asset});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (_) => AssetRepoImpl(),
        child: BlocProvider(
            create: (context) => AddPositionBloc(
                  assetRepo: context.read<AssetRepoImpl>(),
                ),
            child: BlocBuilder<AddPositionBloc, AddPositionState>(
                builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text("Add position"),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: AppBottomFab(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AddPositionBloc>()
                            .add(SavePositionEvent(asset));
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
                                initialValue: asset.name,
                                title: "Asset",
                                readOnly: true,
                                isMandatory: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.m),
                              child: AppDateField(
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
                                isMandatory: true,
                                onTextChange: (value) {
                                  context.read<AddPositionBloc>().add(
                                      ChangeCostEvent(double.parse(value)));
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
