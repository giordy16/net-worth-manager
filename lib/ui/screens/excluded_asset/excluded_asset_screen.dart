import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';

import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';

class HiddenAssetScreen extends StatefulWidget {
  static String path = "/HiddenAssetScreen";

  const HiddenAssetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HiddenAssetScreenState();
}

class _HiddenAssetScreenState extends State<HiddenAssetScreen> {
  Future<void> onItemClick(Asset asset) async {
    bool? yes = await showYesNoBottomSheet(context,
        t.asset_visible_again_message.replaceAll("<asset>", asset.name));

    if (yes == true) {
      asset.excludeFromNW = false;
      GetIt.I<Store>().box<Asset>().put(asset);
      setState(() {});
      ScaffoldWithBottomNavigation.updateScreens();
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
      appBar: AppBar(
        title: Text(t.hidde_asset),
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: excludedAsset.isEmpty
            ? Center(child: Text(t.hidde_asset_empty))
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return IconButton(
                      onPressed: () => onItemClick(excludedAsset[index]),
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.screenMargin,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              excludedAsset[index].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                            const SizedBox(width: Dimensions.s),
                            const Icon(Icons.undo)
                          ],
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return AppDivider();
                },
                itemCount: excludedAsset.length,
              ),
      ),
    );
  }
}
