import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';

import '../../../../models/obox/asset_obox.dart';
import '../asset_detail_bloc.dart';
import '../asset_detail_event.dart';

class AssetDetailHistoryItem extends StatelessWidget {
  Asset asset;
  AssetTimeValue timeValue;

  AssetDetailHistoryItem(
      {super.key, required this.asset, required this.timeValue});

  @override
  Widget build(BuildContext context) {
    DateFormat df = DateFormat("dd/MM/yyyy");

    return Material(
      child: InkWell(
        onTap: () async {
          await context.push(AddAssetPositionScreen.route,
              extra: AddAssetPositionScreenParams(
                asset: asset,
                timeValue: timeValue,
              ));
          context
              .read<AssetDetailBloc>()
              .add(FetchGraphDataEvent());
        },
        child: Row(
          children: [
            Text(df.format(timeValue.date)),
            const Expanded(child: SizedBox()),
            Text(timeValue.getValueWithCurrency()),
          ],
        ),
      ),
    );
  }
}
