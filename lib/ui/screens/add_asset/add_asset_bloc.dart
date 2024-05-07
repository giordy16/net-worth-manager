import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_state.dart';
import 'add_asset_events.dart';

class AddAssetBloc extends Bloc<AddAssetEvent, AddAssetState> {
  final AssetRepo assetRepo;

  AddAssetBloc({
    required this.assetRepo,
  }) : super(const AddAssetState.empty()) {
    on<ChangeNameEvent>((event, emit) {
      emit(state.copyWith(assetName: event.value));
    });

    on<ChangeCategoryEvent>((event, emit) {
      emit(state.copyWith(assetCategory: event.value));
    });

    on<SaveAssetEvent>((event, emit) {
      Asset asset = Asset(state.assetName);
      asset.category.target = state.assetCategory;

      assetRepo.saveNewAsset(asset);
    });

    on<FetchAddAssetData>((event, emit) {
      var categories = assetRepo.getAssetCategories();
      emit(state.copyWith(assetCategorySelectable: categories));
    });
  }
}
