import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/custom_pie_obox.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/base_components/app_bottom_fab.dart';

class AddCustomPieScreen extends StatefulWidget {
  static String route = "AddCustomPieScreen";

  @override
  State<StatefulWidget> createState() => _AddCustomPieScreenState();
}

class _AddCustomPieScreenState extends State<AddCustomPieScreen> {
  final categories = GetIt.I<Store>().box<AssetCategory>().getAll();
  final assets = GetIt.I<Store>().box<Asset>().getAll();

  Set<AssetCategory> selectedCat = {};
  Set<Asset> selectedAsset = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: selectedCat.length + selectedAsset.length > 1,
        child: AppBottomFab(
          text: "Save",
          onTap: () {
            CustomPie pie = CustomPie("Custom allocation");
            pie.assets.addAll(selectedAsset);
            pie.categories.addAll(selectedCat);

            GetIt.I<Store>().box<CustomPie>().put(pie);
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
          child: ListView(
            children: [
              Text("Create your custom allocation chart"),
              SizedBox(height: Dimensions.l),
              Text("Categories",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              ...categories
                  .map((cat) => Row(
                        children: [
                          Text(cat.name),
                          Expanded(child: SizedBox()),
                          Checkbox(
                              value: selectedCat.contains(cat),
                              onChanged: (value) {
                                if (value == true) {
                                  selectedCat.add(cat);
                                } else if (value == false) {
                                  selectedCat.remove(cat);
                                }
                                setState(() {});
                              })
                        ],
                      ))
                  .toList(),
              SizedBox(height: Dimensions.l),
              Text("Assets",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              ...assets
                  .map((asset) => Row(
                        children: [
                          Text(asset.name),
                          Expanded(child: SizedBox()),
                          Checkbox(
                              value: selectedAsset.contains(asset),
                              onChanged: (value) {
                                if (value == true) {
                                  selectedAsset.add(asset);
                                } else if (value == false) {
                                  selectedAsset.remove(asset);
                                }
                                setState(() {});
                              })
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
