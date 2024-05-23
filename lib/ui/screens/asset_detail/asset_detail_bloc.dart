import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/domain/repository/stock/StockApi.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/ui/graph_data.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_event.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_state.dart';
import 'package:net_worth_manager/utils/background_thread.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

import '../../../models/obox/asset_history_time_value.dart';
import '../../../models/obox/asset_obox.dart';

List<DateTime> topLevelDate = [DateTime.now()];

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  final Asset asset;
  final AssetRepo assetRepo;
  final StockApi stockApi;

  AssetDetailBloc(this.asset, this.assetRepo, this.stockApi)
      : super(AssetDetailState(asset, const [])) {
    on<FetchGraphDataEvent>(_onFetchGraphDataEvent);

    on<FetchGraphDataCompletedEvent>((event, emit) {
      emit(state.copyWith(asset: event.asset, graphData: event.list));
    });
  }

  Future<void> _onFetchGraphDataEvent(
    FetchGraphDataEvent event,
    Emitter<AssetDetailState> emit,
  ) async {
    Asset asset = objectbox.store.box<Asset>().get(this.asset.id)!;

    if (asset.timeValues.isEmpty) return;

    if (asset.marketInfo.target == null) {
      // simple asset

      DateTime firstInvestmentDate =
          asset.getTimeValuesChronologicalOrder().first.date;
      int daysToLoop = DateTime.now().difference(firstInvestmentDate).inDays;

      List<DateTime> days = [];
      for (int i = 0; i <= daysToLoop; i++) {
        days.add(firstInvestmentDate.add(Duration(days: i)).keepOnlyYMT());
      }

      List<GraphData> graphData = await runInDifferentThread(() {
        return days
            .map((e) => GraphData(e, asset.getValueAtDateTime(e)))
            .toList();
      });

      add(FetchGraphDataCompletedEvent(asset, graphData));
    } else {
      // market asset

      List<AssetHistoryTimeValue> list = await stockApi.getPriceHistoryBySymbol(
            asset.marketInfo.target!,
            asset.getTimeValuesChronologicalOrder().firstOrNull?.date,
          ) ??
          [];

      List<GraphData> graphData = await runInDifferentThread(() {
        return list
            .map((e) => GraphData(e.date, asset.getValueAtDateTime(e.date)))
            .toList();
      });

      add(FetchGraphDataCompletedEvent(asset, graphData));
    }
  }
}
