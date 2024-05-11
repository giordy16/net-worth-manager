import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_event.dart';

import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final AssetRepo assetRepo;

  HomePageBloc({
    required this.assetRepo,
  }) : super(const HomePageState()) {

    on<FetchHomePage>((event, emit) {
      List<Asset> assets = assetRepo.getAssets();

      emit(state.copyWith(
        assets: assets,
        netWorthValue: assetRepo.getCurrentNetWorth(),
      ));
    });

    on<DeleteAsset>((event, emit) {
      assetRepo.deleteAsset(event.asset);
    });

    on<DeleteCategory>((event, emit) {
      assetRepo.deleteCategory(event.category);
    });
  }
}
