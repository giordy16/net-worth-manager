import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/domain/repository/stock/stock_api.dart';
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

    List<GraphData> graphData = [];

    DateTime oldestDateTime =
        asset.getTimeValuesChronologicalOrder().first.date;

    for (int i = 0;
        i < DateTime.now().keepOnlyYMD().difference(oldestDateTime).inDays;
        i++) {
      DateTime date = oldestDateTime.add(Duration(days: i)).keepOnlyYMD();
      graphData.add(GraphData(date, assetRepo.getValueAtDateTime(asset, date)));
    }

    // add one top plot graph until the end
    graphData.add(GraphData(DateTime.now(), graphData.last.y));

    add(FetchGraphDataCompletedEvent(asset, graphData));
  }
}
