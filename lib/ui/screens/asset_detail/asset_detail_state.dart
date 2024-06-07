import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import '../../../models/ui/graph_data.dart';

class AssetDetailState extends Equatable {
  Asset asset;
  List<GraphData> graphData;

  AssetDetailState(this.asset, this.graphData);

  @override
  List<Object?> get props => [asset, graphData];

  AssetDetailState copyWith({
    Asset? asset,
    List<GraphData>? graphData,
  }) {
    return AssetDetailState(
      asset ?? this.asset,
      graphData ?? this.graphData,
    );
  }
}
