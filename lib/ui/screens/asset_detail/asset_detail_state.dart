import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/utils/enum/graph_data_gap_enum.dart';
import '../../../models/ui/graph_data.dart';

class AssetDetailState extends Equatable {
  Asset asset;
  List<GraphData> graphData;
  List<GraphData> secondGraphData;
  GraphTime graphTime;
  double? performance;
  double? performancePerc;

  AssetDetailState(
    this.asset,
    this.graphData,
    this.secondGraphData,
    this.graphTime,
    this.performance,
    this.performancePerc,
  );

  @override
  List<Object?> get props => [
        asset,
        graphData,
        secondGraphData,
        graphTime,
        performance,
        performancePerc
      ];

  AssetDetailState copyWith(
      {Asset? asset,
      List<GraphData>? graphData,
      List<GraphData>? secondGraphData,
      GraphTime? graphTime,
      double? performance,
      double? performancePerc}) {
    return AssetDetailState(
      asset ?? this.asset,
      graphData ?? this.graphData,
      secondGraphData ?? this.secondGraphData,
      graphTime ?? this.graphTime,
      performance ?? this.performance,
      performancePerc ?? this.performancePerc,
    );
  }
}
