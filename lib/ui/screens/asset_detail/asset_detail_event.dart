import 'package:net_worth_manager/models/obox/asset_obox.dart';

import '../../../models/ui/graph_data.dart';

abstract class AssetDetailEvent {}

class FetchGraphDataEvent extends AssetDetailEvent {}

class FetchGraphDataCompletedEvent extends AssetDetailEvent {
  Asset asset;
  List<GraphData> list;

  FetchGraphDataCompletedEvent(this.asset, this.list);
}