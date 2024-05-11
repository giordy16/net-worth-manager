import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_selection/component/add_selection_item.dart';

class AddSelectionScreen extends StatelessWidget {
  static const route = "/AddSelectionScreen";

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
              AddSelectionItem(
                  "Real-time asset",
                  "Add your stocks so that we can track them an automatically store their value",
                  () {}),
              const SizedBox(height: Dimensions.m),
              AddSelectionItem("Normal asset",
                  "Crete your assets an manually set their value", () {
                context.push(AddAssetScreen.route);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
