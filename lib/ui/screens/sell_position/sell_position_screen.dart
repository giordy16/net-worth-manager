import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/app_dimensions.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/base_components/app_selector_field.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';

class SellPositionScreen extends StatefulWidget {
  static String path = "/SellPositionScreen";

  AddAssetPositionScreenParams params;

  SellPositionScreen(this.params);

  @override
  State<StatefulWidget> createState() => _SellPositionScreenState();
}

class _SellPositionScreenState extends State<SellPositionScreen> {
  Asset? selectedAsset;

  @override
  Widget build(BuildContext context) {
    final selectableAsset = GetIt.I<Store>()
        .box<Asset>()
        .query(Asset_.id.notEquals(widget.params.asset.id) &
            Asset_.marketInfo.isNull())
        .build()
        .find();

    return Scaffold(
      appBar: AppBar(
        title: Text("Sell position"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
          child: ListView(
            children: [
              Text(
                  "Select to which asset the value of the position should be moved"),
              SizedBox(height: Dimensions.s),
              AppSelectorField<Asset>(
                title: "Asset",
                initialValue: selectedAsset,
                values: selectableAsset,
                onItemSelected: (value) {
                  selectedAsset = value;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
