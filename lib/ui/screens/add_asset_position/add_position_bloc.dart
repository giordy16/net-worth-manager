import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_event.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_position_state.dart';

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
    on<SavePositionEvent>((event, emit) {
      var position = event.position;
      if (event.asset.marketInfo.target == null) {
        position.currency.target = objectbox.store
            .box<Settings>()
            .getAll()
            .first
            .defaultCurrency
            .target;
      } else {
        position.currency.target = objectbox.store
            .box<Currency>()
            .query(
                Currency_.name.equals(event.asset.marketInfo.target!.currency))
            .build()
            .find()
            .first;
      }

      assetRepo.saveAssetPosition(
        position,
        event.asset,
      );
      context.pop(position);
    });

    on<DeletePositionEvent>((event, emit) {
      assetRepo.deletePosition(event.asset, event.position);
    });
  }
}
