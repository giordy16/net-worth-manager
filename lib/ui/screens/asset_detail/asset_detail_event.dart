import 'package:net_worth_manager/models/obox/asset_obox.dart';

import '../../../models/ui/graph_data.dart';
import '../../../utils/enum/graph_data_gap_enum.dart';

abstract class AssetDetailEvent {}

class FetchGraphDataEvent extends AssetDetailEvent {}

class UpdateAssetEvent extends AssetDetailEvent {
  Asset assetUpdated;

  UpdateAssetEvent(this.assetUpdated);
}

class UpdatePerformanceEvent extends AssetDetailEvent {
  GraphTime gap;

  UpdatePerformanceEvent(this.gap);
}

class FetchGraphDataCompletedEvent extends AssetDetailEvent {
  Asset asset;
  List<GraphData> list;
  List<GraphData>? secondList;

  FetchGraphDataCompletedEvent(this.asset, this.list, this.secondList);
}

class DeleteAssetADEvent extends AssetDetailEvent {
  Asset asset;

  DeleteAssetADEvent(this.asset);
}