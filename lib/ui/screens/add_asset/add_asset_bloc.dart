import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_state.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'package:net_worth_manager/ui/widgets/modal/user_message.dart';
import 'package:net_worth_manager/utils/ad_mob.dart';
import '../../../i18n/strings.g.dart';
import '../../widgets/modal/loading_overlay.dart';
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
      LoadingOverlay.of(context).show();

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

      ADMob.showPopUpAd(onAdDismissed: () {
        LoadingOverlay.of(context).hide();
        UserMessage.showMessage(context, t.done);
        context.pop();
      });
    });

    on<SaveAssetAndOpenPositionEvent>((event, emit) {
      LoadingOverlay.of(context).show();

      Asset asset = Asset(state.assetName);
      asset.category.target = state.assetCategory;

      assetRepo.saveAsset(asset);

      ADMob.showPopUpAd(onAdDismissed: () {
        LoadingOverlay.of(context).hide();
        context.pushReplacement(AddAssetPositionScreen.route,
            extra: AddAssetPositionScreenParams(
              asset: asset,
              mode: AddAssetPositionScreenMode.add,
            ));
      });
    });

    on<FetchAddAssetData>((event, emit) {
      var categories = assetRepo.getAssetCategories(onlyManualAssetCat: true);
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
