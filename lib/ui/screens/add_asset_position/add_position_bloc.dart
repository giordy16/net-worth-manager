import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/domain/repository/stock/stock_api.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_state.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../../utils/enum/fetch_forex_type.dart';
import '../../widgets/modal/user_message.dart';
import 'add_asset_position_screen.dart';

class AddPositionBloc extends Bloc<AddPositionEvent, AddPositionState> {
  BuildContext context;
  final AssetRepo assetRepo;
  final NetWorthRepo netWorthRepo;
  final StockApi stockApi;
  final AddAssetPositionScreenMode mode;

  AddPositionBloc({
    required this.assetRepo,
    required this.netWorthRepo,
    required this.stockApi,
    required this.context,
    required this.mode,
  }) : super(AddPositionState()) {
    on<SavePositionEvent>((event, emit) async {
      LoadingOverlay.of(context).show();

      if (event.asset.marketInfo.target != null) {
        double? qtAfterSplit = await assetRepo.checkShareSplit(
          context,
          event.asset.marketInfo.target!.symbol,
          event.position,
        );

        if (qtAfterSplit != null) {
          event.position.quantity = qtAfterSplit;
        }
      }

      assetRepo.saveAssetPosition(
        event.position,
        event.asset,
      );

      await GetIt.I<Store>().syncForexPrices(
          fetchType: FMPFetchType.addPosition,
          startFetchDate: event.position.date);

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

        await netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
      }

      LoadingOverlay.of(context).hide();
      UserMessage.showMessage(context, t.done);
      context.pop();
    });

    on<DeletePositionEvent>((event, emit) async {
      DateTime? oldestDate = event.asset.getOldestTimeValueDate();

      assetRepo.deletePosition(event.asset, event.position);

      if (oldestDate != null) {
        LoadingOverlay.of(context).show();
        await netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
        await LoadingOverlay.of(context).hide();
      }

      UserMessage.showMessage(context, t.position_deleted);
      context.pop();
    });
  }
}
