import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/models/obox/net_worth_history.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/models/ui/graph_data.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_event.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';
import 'package:net_worth_manager/utils/enum/graph_data_gap_enum.dart';
import '../../../objectbox.g.dart';
import '../../scaffold_with_bottom_navigation.dart';
import '../../widgets/modal/user_message.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final AssetRepo assetRepo;
  final NetWorthRepo netWorthRepo;
  final BuildContext context;

  bool shouldUpdatePage = true;

  HomePageBloc({
    required this.context,
    required this.assetRepo,
    required this.netWorthRepo,
  }) : super(HomePageState()) {
    on<FetchHomePage>((event, emit) {
      debugPrint("FetchHomePage START");

      if (event.gap != null) {
        // when event.gap != null means that the user changed the time of the graph,
        // so let's save the preference
        final settings = GetIt.I<Settings>();
        settings.homeGraphIndex = GraphTime.values.indexOf(event.gap!);
        GetIt.I<Store>().box<Settings>().put(settings);
      }

      List<Asset> assets = assetRepo
          .getAssets()
          .where((element) => element.excludeFromNW != true)
          .toList();

      emit(state.copyWith(
          assets: assets,
          graphGap: event.gap,
          netWorthValue: netWorthRepo.getNetWorth(),
          graphData: []));

      List<GraphData> graphData = GetIt.I<Store>()
          .box<NetWorthHistory>()
          .query()
          .order(NetWorthHistory_.date)
          .build()
          .find()
          .map((e) => GraphData(e.date, e.value))
          .toList();

      emit(state.copyWith(graphData: graphData));

      if (graphData.isNotEmpty) {
        DateTime oldestDate = graphData.first.x;

        double? oldestValue = graphData
            .where((data) =>
                data.x == state.graphGap!.getStartDate(oldestDate) ||
                data.x.isAfter(state.graphGap!.getStartDate(oldestDate)))
            .toList()
            .firstOrNull
            ?.y;

        if (oldestValue != null) {
          double performance = graphData.last.y - oldestValue;
          double performancePerc = performance / oldestValue * 100;

          emit(state.copyWith(
            performance: double.parse(performance.toStringAsFixed(2)),
            performancePerc: double.parse(performancePerc.toStringAsFixed(1)),
          ));
        }
      }
      debugPrint("FetchHomePage END");
    });

    on<DeleteAsset>((event, emit) async {
      debugPrint("DeleteAsset START");
      DateTime? oldestDate = event.asset.getOldestTimeValueDate();

      assetRepo.deleteAsset(event.asset);

      if (oldestDate != null) {
        LoadingOverlay.of(context).show();
        await netWorthRepo.updateNetWorth(updateStartingDate: oldestDate);
        LoadingOverlay.of(context).hide();
      }

      add(FetchHomePage());
      ScaffoldWithBottomNavigation.updateScreens();
      UserMessage.showMessage(context, "Deleted!");
      debugPrint("DeleteAsset END");
    });

    on<HideAsset>((event, emit) async {
      event.asset.excludeFromNW = true;
      GetIt.I<Store>().box<Asset>().put(event.asset);

      add(FetchHomePage());
      ScaffoldWithBottomNavigation.updateScreens();
    });

    on<DeleteCategory>((event, emit) async {
      List<int> oldestPositionDateList = assetRepo
          .getAssetsFromCategory(event.category)
          .map(
              (asset) => asset.getOldestTimeValueDate()?.millisecondsSinceEpoch)
          .nonNulls
          .toList();

      assetRepo.deleteCategory(event.category);

      if (oldestPositionDateList.isNotEmpty) {
        LoadingOverlay.of(context).show();
        await netWorthRepo.updateNetWorth(
            updateStartingDate: DateTime.fromMillisecondsSinceEpoch(
                oldestPositionDateList.reduce(min)));
        LoadingOverlay.of(context).hide();
      }

      add(FetchHomePage());
      ScaffoldWithBottomNavigation.updateScreens();
      UserMessage.showMessage(context, "Deleted!");
    });
  }
}
