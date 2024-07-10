import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_selection/component/add_selection_item.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_screen.dart';

import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';

class AddSelectionScreen extends StatelessWidget {
  static const route = "/AddSelectionScreen";
  static Asset addNewAsset = Asset(t.create_new_asset_liability);

  const AddSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenMargin),
          child: ListView(
            children: [
              Text(t.add_selection_subtitle),
              const SizedBox(height: Dimensions.m),
              AddSelectionItem(
                t.add_selection_market_title,
                t.add_selection_market_subtitle,
                () {
                  context.push(TickerSearchScreen.route);
                },
              ),
              const SizedBox(height: Dimensions.m),
              AddSelectionItem(
                t.add_selection_manual_title,
                t.add_selection_manual_subtitle,
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
