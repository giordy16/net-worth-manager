import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/models/ui/graph_data.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_event.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_state.dart';
import 'package:net_worth_manager/utils/background_thread.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../../utils/enum/graph_data_gap_enum.dart';
import '../../scaffold_with_bottom_navigation.dart';
import '../../widgets/modal/loading_overlay.dart';

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  final Asset asset;
  final BuildContext context;
  final AssetRepo assetRepo;
  final NetWorthRepo netWorthRepo;

  AssetDetailBloc(this.asset, this.context, this.assetRepo, this.netWorthRepo)
      : super(AssetDetailState.empty(asset)) {
    on<FetchGraphDataEvent>(_onFetchGraphDataEvent);

    on<UpdatePerformanceEvent>((event, emit) {
      emit(state.copyWith(graphTime: event.gap));

      // show percentage only for market asset
      if (asset.marketInfo.target == null) {
        return;
      }

      if (state.graphData!.isNotEmpty) {
        DateTime oldestDate = asset.getOldestTimeValueDate()!;

        double performance = asset.getPerformance(
            startDateTime: event.gap.getStartDate(oldestDate));
        double performancePerc = asset.getPerformancePerc(
            startDateTime: event.gap.getStartDate(oldestDate));

        emit(state.copyWith(
          performance: double.parse(performance.toStringAsFixed(2)),
          performancePerc: double.parse(performancePerc.toStringAsFixed(1)),
        ));
      }
    });

    on<FetchGraphDataCompletedEvent>((event, emit) {
      emit(state.copyWith(
          asset: event.asset,
          graphData: event.list,
          secondGraphData: event.secondList));
      add(UpdatePerformanceEvent(state.graphTime));
    });

    on<UpdateAssetEvent>((event, emit) {
      assetRepo.saveAsset(event.assetUpdated);
      emit(state.copyWith(asset: event.assetUpdated));
    });

  }

  Future<void> _onFetchGraphDataEvent(
    FetchGraphDataEvent event,
    Emitter<AssetDetailState> emit,
  ) async {
    Asset asset = GetIt.I<Store>().box<Asset>().get(this.asset.id)!;

    emit(state.copyWith(asset: asset));

    if (asset.timeValues.isEmpty) {
      emit(AssetDetailState.empty(asset));
      return;
    }

    DateTime oldestDateTime =
        asset.getTimeValuesChronologicalOrder().first.date;
    int daysToLoop =
        DateTime.now().keepOnlyYMD().difference(oldestDateTime).inDays;

    List<GraphData> graphData = await runInDifferentThread(() {
      List<GraphData> _graphData = [];

      for (int i = 0; i < daysToLoop; i++) {
        DateTime date = oldestDateTime.add(Duration(days: i)).keepOnlyYMD();
        _graphData.add(
            GraphData(date, AssetRepoImpl().getValueAtDateTime(asset, date)));
      }

      return _graphData;
    });

    // in case there is only 1 asset.timeValues and has the date of today,
    // the for above will not loop, so we need to out the data manually
    if (asset.timeValues.length == 1 &&
        oldestDateTime == DateTime.now().keepOnlyYMD()) {
      graphData.add(GraphData(
          oldestDateTime, assetRepo.getValueAtDateTime(asset, oldestDateTime)));
    }

    List<GraphData>? secondGraphData = [];

    if (asset.marketInfo.target != null) {
      for (var position in asset.getTimeValuesChronologicalOrder()) {
        secondGraphData.add(GraphData(position.date,
            asset.getTotalAmountInvested(dateTime: position.date)));
      }
    } else {
      secondGraphData = null;
    }

    add(FetchGraphDataCompletedEvent(asset, graphData, secondGraphData));
  }
}
