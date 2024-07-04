import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/models/obox/custom_pie_obox.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_text_field.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/base_components/app_bottom_fab.dart';

class AddCustomPieScreen extends StatefulWidget {
  static String route = "/AddCustomPieScreen";

  CustomPie? customPie;

  AddCustomPieScreen(this.customPie);

  @override
  State<StatefulWidget> createState() => _AddCustomPieScreenState();
}

class _AddCustomPieScreenState extends State<AddCustomPieScreen> {
  final categories = GetIt.I<Store>().box<AssetCategory>().getAll();
  final assets = GetIt.I<Store>().box<Asset>().getAll();

  Set<AssetCategory> selectedCat = {};
  Set<Asset> selectedAsset = {};

  String allocationName = "";

  @override
  void initState() {
    if (widget.customPie != null) {
      allocationName = widget.customPie!.name;
      selectedCat.addAll(widget.customPie!.categories);
      selectedAsset.addAll(widget.customPie!.assets);
    }

    super.initState();
  }

  void save() {
    if (widget.customPie == null) {
      CustomPie pie = CustomPie(allocationName);
      pie.assets.addAll(selectedAsset);
      pie.categories.addAll(selectedCat);
      GetIt.I<Store>().box<CustomPie>().put(pie);
    } else {
      widget.customPie!.name = allocationName;

      widget.customPie!.assets.removeWhere((_) => true);
      widget.customPie!.categories.removeWhere((_) => true);

      widget.customPie!.assets.addAll(selectedAsset);
      widget.customPie!.categories.addAll(selectedCat);
      GetIt.I<Store>().box<CustomPie>().put(widget.customPie!);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create allocation chart"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: selectedCat.length + selectedAsset.length > 1,
        child: AppBottomFab(
          text: "Save",
          onTap: save,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.screenMargin),
          child: ListView(
            children: [
              SizedBox(height: Dimensions.s),
              Text(
                "Choose a name for this chart",
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: Dimensions.s),
              AppTextField(
                  isMandatory: true,
                  title: "Name",
                  initialValue: allocationName,
                  onTextChange: (name) {
                    allocationName = name;
                  }),
              SizedBox(height: Dimensions.xl),
              Text(
                "Select the categories or assets you want to add to the pie chart",
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: Dimensions.s),
              Text("Categories",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              ...categories
                  .map((cat) => Row(
                        children: [
                          Expanded(child: Text(cat.name)),
                          SizedBox(width: 4,),
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
              SizedBox(height: Dimensions.m),
              Text("Assets",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              ...assets
                  .map((asset) => Row(
                        children: [
                          Expanded(child: Text(asset.name)),
                          SizedBox(width: 4,),
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
