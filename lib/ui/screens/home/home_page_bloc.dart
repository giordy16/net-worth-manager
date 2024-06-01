import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/models/obox/net_worth_history.dart';
import 'package:net_worth_manager/models/ui/graph_data.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_event.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';
import '../../../objectbox.g.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final AssetRepo assetRepo;
  final NetWorthRepo netWorthRepo;

  HomePageBloc({
    required this.assetRepo,
    required this.netWorthRepo,
  }) : super(const HomePageState()) {
    on<FetchHomePage>((event, emit) {
      List<Asset> assets = assetRepo.getAssets();

      emit(state.copyWith(
        assets: assets,
        netWorthValue: netWorthRepo.getNetWorth(),
        graphData: []
      ));

      List<GraphData> graphData = GetIt.I<Store>()
          .box<NetWorthHistory>()
          .query()
          .order(NetWorthHistory_.date)
          .build()
          .find()
          .map((e) => GraphData(e.date, e.value))
          .toList();

      emit(state.copyWith(graphData: graphData));
    });

    on<DeleteAsset>((event, emit) {
      assetRepo.deleteAsset(event.asset);
    });

    on<DeleteCategory>((event, emit) {
      assetRepo.deleteCategory(event.category);
    });
  }
}
