import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_state.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../main.dart';
import '../../../models/obox/currency_obox.dart';
import '../../../objectbox.g.dart';

class AddPositionBloc extends Bloc<AddPositionEvent, AddPositionState> {
  BuildContext context;
  final AssetRepo assetRepo;

  AddPositionBloc({
    required this.assetRepo,
    required this.context,
  }) : super(const AddPositionState()) {
    on<SavePositionEvent>((event, emit) async {
      assetRepo.saveAssetPosition(
        event.position,
        event.asset,
      );

      // todo show loader
      await objectbox.syncForexPrices();

      context.pop();
    });

    on<DeletePositionEvent>((event, emit) {
      assetRepo.deletePosition(event.asset, event.position);
    });
  }
}
