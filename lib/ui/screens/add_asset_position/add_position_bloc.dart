import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_state.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../main.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../objectbox.g.dart';

class AddPositionBloc extends Bloc<AddPositionEvent, AddPositionState> {
  BuildContext context;
  final AssetRepo assetRepo;
  final NetWorthRepo netWorthRepo;

  AddPositionBloc({
    required this.assetRepo,
    required this.netWorthRepo,
    required this.context,
  }) : super(const AddPositionState()) {
    on<SavePositionEvent>((event, emit) async {
      assetRepo.saveAssetPosition(
        event.position,
        event.asset,
      );

      // todo show loader
      await objectbox.syncForexPrices();

      var assetPositionsDate = GetIt.I<Store>()
              .box<Asset>()
              .get(event.asset.id)
              ?.timeValues
              .map((element) => element.date)
              .toList() ??
          [];
      if (assetPositionsDate.isNotEmpty) {
        DateTime oldestDate =
            assetPositionsDate.reduce((a, b) => a.isBefore(b) ? a : b);

        netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
      }

      context.pop();
    });

    on<DeletePositionEvent>((event, emit) {
      assetRepo.deletePosition(event.asset, event.position);
    });
  }
}
