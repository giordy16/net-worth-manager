import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/models/ui/graph_data.dart';
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
        netWorthValue: assetRepo.getNetWorth(),
      ));

      // fetch graph data

      var start = DateTime.now();

      List<DateTime> oldestAssetsFirstBuys = assets
          .map((asset) =>
              asset.getTimeValuesChronologicalOrder().firstOrNull?.date)
          .nonNulls
          .toList();

      if (oldestAssetsFirstBuys.isEmpty) {
        emit(state.copyWith(graphData: []));
        return;
      }

      DateTime oldestAssetData =
          oldestAssetsFirstBuys.reduce((a, b) => a.isBefore(b) ? a : b);

      print("1: ${DateTime.now().difference(start)}");

      int daysToLoop = DateTime.now().difference(oldestAssetData).inDays;

      List<GraphData> graphData = [];
      print("daysToLoop ${daysToLoop}");

      print("2: ${DateTime.now().difference(start)}");
      for (int i = 0; i <= daysToLoop; i++) {
        DateTime dateTime = oldestAssetData.add(Duration(days: i));
        print("dateTime $dateTime");
        double dayValue = 0;
        for (var asset in assets) {
          dayValue = dayValue + asset.getValueAtDateTime(dateTime);
        }
        graphData.add(GraphData(dateTime, dayValue));
      }

      print("3: ${DateTime.now().difference(start)}");

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
