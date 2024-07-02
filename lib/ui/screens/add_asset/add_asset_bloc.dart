import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_state.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'add_asset_events.dart';

class AddAssetBloc extends Bloc<AddAssetEvent, AddAssetState> {
  final AssetRepo assetRepo;
  final BuildContext context;

  AddAssetBloc({
    required this.assetRepo,
    required this.context,
  }) : super(const AddAssetState.empty()) {
    on<ChangeNameEvent>((event, emit) {
      emit(state.copyWith(assetName: event.value));
    });

    on<ChangeCategoryEvent>((event, emit) {
      emit(state.copyWith(assetCategory: event.value));
    });

    on<SaveAssetEvent>((event, emit) {
      Asset asset;
      if (event.asset != null) {
        asset = event.asset!;
        asset.name = state.assetName;
        asset.category.target = state.assetCategory;
      } else {
        asset = Asset(state.assetName);
        asset.category.target = state.assetCategory;
      }
      assetRepo.saveAsset(asset);
    });

    on<SaveAssetAndOpenPositionEvent>((event, emit) {
      Asset asset = Asset(state.assetName);
      asset.category.target = state.assetCategory;

      assetRepo.saveAsset(asset);
      context.pushReplacement(AddAssetPositionScreen.route,
          extra: AddAssetPositionScreenParams(asset: asset));
    });

    on<FetchAddAssetData>((event, emit) {
      var categories = assetRepo.getAssetCategories();
      emit(state.copyWith(assetCategorySelectable: categories));
    });

    on<SetInitialValue>((event, emit) {
      if (event.asset != null) {
        emit(state.copyWith(
          assetName: event.asset!.name,
          assetCategory: event.asset!.category.target,
        ));
      }
    });
  }
}
