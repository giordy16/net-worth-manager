import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/widgets/app_divider.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_bottom_fab.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_date_field.dart';
import 'package:net_worth_manager/ui/widgets/base_components/app_numeric_text_field.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../app_dimensions.dart';
import '../../../i18n/strings.g.dart';
import '../../../objectbox.g.dart';
import '../../widgets/modal/loading_overlay.dart';
import '../../widgets/modal/user_message.dart';

class UpdateAssetPair {
  DateTime dateTime;
  double value;

  UpdateAssetPair(this.dateTime, this.value);
}

class UpdateAssetValueScreen extends StatefulWidget {
  static String path = "/UpdateAssetValueScreen";

  @override
  State<StatefulWidget> createState() => _UpdateAssetValueState();
}

class _UpdateAssetValueState extends State<UpdateAssetValueScreen> {
  late List<Asset> assets;
  late List<UpdateAssetPair> values;

  @override
  void initState() {
    // we update only the values of simple asset
    assets = GetIt.I<Store>()
        .box<Asset>()
        .query()
        .order(Asset_.name)
        .build()
        .find()
        .where((a) => a.marketInfo.target == null)
        .toList();

    values = assets
        .map((a) =>
            UpdateAssetPair(DateTime.now().keepOnlyYMD(), a.getCurrentValue()))
        .toList();
    super.initState();
  }

  Future<void> savePositions() async {
    for (int i = 0; i < assets.length; i++) {
      AssetRepoImpl().saveAssetPosition(
          AssetTimeValue(date: values[i].dateTime, value: values[i].value),
          assets[i]);
    }

    int oldestDate = values
        .map((e) => e.dateTime.millisecondsSinceEpoch)
        .toList()
        .reduce(min);

    LoadingOverlay.of(context).show();

    await NetWorthRepoImpl().updateNetWorth(
        updateStartingDate: DateTime.fromMillisecondsSinceEpoch(oldestDate));
    ScaffoldWithBottomNavigation.updateScreens();
    LoadingOverlay.of(context).hide();
    UserMessage.showMessage(context, t.done);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // todo handle case empty list

    return Scaffold(
        appBar: AppBar(
          title: Text(t.update_asset_values),
          surfaceTintColor: Theme.of(context).colorScheme.surface,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(Dimensions.screenMargin),
                child: assets.isEmpty
                    ? Center(
                        child: Text(
                            t.update_asset_empty,
                        style: theme.textTheme.bodyMedium?.copyWith(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView(
                        children: [
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Asset currentAsset = assets[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentAsset.name,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: AppDateField(
                                          title: t.date,
                                          initialValue: values[index].dateTime,
                                          onDatePicked: (date) {
                                            values[index].dateTime = date;
                                          },
                                        )),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: AppNumericTextField(
                                          moneyBehavior: true,
                                          userCanChangeCurrency: false,
                                          initialValue: values[index].value,
                                          title: t.value,
                                          onTextChange: (text) {
                                            values[index].value =
                                                double.tryParse(text) ?? 0;
                                          },
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return AppDivider();
                            },
                            itemCount: assets.length,
                          ),
                          SizedBox(height: Dimensions.l),
                          AppBottomFab(
                            text: t.save,
                            onTap: savePositions,
                            horizontalMargin: 0,
                          )
                        ],
                      ))));
  }
}
