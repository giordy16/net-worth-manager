import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_selection/component/add_selection_item.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_screen.dart';

import '../../../models/obox/asset_obox.dart';

class AddSelectionScreen extends StatelessWidget {
  static const route = "/AddSelectionScreen";
  static Asset addNewAsset = Asset("+ Create new asset/liability");

  const AddSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              const Text("Select which kind of asset you want to add:"),
              const SizedBox(height: Dimensions.m),
              AddSelectionItem(
                "Market Investment (ETF/Stock/Crypto)",
                "Add your investments in the stock market.\nTheir value will be automatically calculated day by day",
                () {
                  context.push(TickerSearchScreen.route);
                },
              ),
              const SizedBox(height: Dimensions.m),
              AddSelectionItem(
                "Manual Asset or Liability",
                "Add your asset or liability that are part of the net worth.\nExample of assets are house, car, cash, valuable collections, watches, ...",
                () {
                  context.push(AddAssetScreen.route);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
