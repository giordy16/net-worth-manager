import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';

class HiddenAssetScreen extends StatefulWidget {
  static String path = "/HiddenAssetScreen";

  @override
  State<StatefulWidget> createState() => _HiddenAssetScreenState();
}

class _HiddenAssetScreenState extends State<HiddenAssetScreen> {
  Future<void> onItemClick(Asset asset) async {
    bool? yes = await showYesNoBottomSheet(
        context, "Do you want to make ${asset.name} visible again?");

    if (yes == true) {
      asset.excludeFromNW = false;
      GetIt.I<Store>().box<Asset>().put(asset);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final excludedAsset = GetIt.I<Store>()
        .box<Asset>()
        .query(Asset_.excludeFromNW.equals(true))
        .build()
        .find();

    return Scaffold(
      appBar: AppBar(title: Text("Excluded assets")),
      body: SafeArea(
        child: excludedAsset.isEmpty
            ? Center(child: Text("You don't have any hidden asset"))
            : Padding(
                padding: const EdgeInsets.all(Dimensions.screenMargin),
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return IconButton(
                        onPressed: () =>  onItemClick(excludedAsset[index]),
                        icon: Row(
                          children: [
                            Expanded(
                                child: Text(
                              excludedAsset[index].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                            SizedBox(width: Dimensions.s),
                            Icon(Icons.undo)
                          ],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return AppDivider();
                  },
                  itemCount: excludedAsset.length,
                ),
              ),
      ),
    );
  }
}
