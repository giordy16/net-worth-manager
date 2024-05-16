import 'package:bloc/bloc.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo.dart';
import 'package:net_worth_manager/domain/repository/stock/StockApi.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_event.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_state.dart';

import '../../../models/obox/asset_history_time_value.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../models/ui/graph_data.dart';

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  final Asset asset;
  final AssetRepo assetRepo;
  final StockApi stockApi;

  AssetDetailBloc(this.asset, this.assetRepo, this.stockApi)
      : super(AssetDetailState(asset, [])) {
    on<FetchGraphDataEvent>((event, emit) async {
      Asset asset = objectbox.store.box<Asset>().get(this.asset.id)!;

      if (asset.marketInfo.target == null) {
        // simple asset
        add(FetchGraphDataCompletedEvent(
            asset,
            asset
                .getTimeValuesChronologicalOrder()
                .map((e) => GraphData(e.date, e.value))
                .toList()));
      } else {
        // market asset
        List<AssetHistoryTimeValue> list =
            await stockApi.getPriceHistoryBySymbol(
                  asset.marketInfo.target!,
                  asset.getTimeValuesChronologicalOrder().firstOrNull?.date,
                ) ??
                [];

        add(FetchGraphDataCompletedEvent(
            asset,
            list
                .map((e) => GraphData(e.date, asset.getValueAtDateTime(e.date)))
                .toList()));
      }
    });

    on<FetchGraphDataCompletedEvent>((event, emit) {
      emit(state.copyWith(asset: event.asset, graphData: event.list));
    });
  }
}
