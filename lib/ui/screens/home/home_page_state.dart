import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/utils/enum/graph_data_gap_enum.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../models/ui/graph_data.dart';

class HomePageState extends Equatable {
  final double? netWorthValue;
  final List<Asset>? assets;
  final List<GraphData>? graphData;
  GraphTime? graphGap;
  double? performance;
  double? performancePerc;

  HomePageState({
    this.netWorthValue,
    this.assets,
    this.graphData,
    this.graphGap = GraphTime.all,
    this.performance,
    this.performancePerc,
  });

  HomePageState copyWith({
    double? netWorthValue,
    List<Asset>? assets,
    List<GraphData>? graphData,
    GraphTime? graphGap,
    double? performance,
    double? performancePerc,
  }) {
    return HomePageState(
      netWorthValue: netWorthValue ?? this.netWorthValue,
      assets: assets ?? this.assets,
      graphData: graphData ?? this.graphData,
      graphGap: graphGap ?? this.graphGap,
      performance: performance ?? this.performance,
      performancePerc: performancePerc ?? this.performancePerc,
    );
  }

  @override
  List<Object?> get props => [
        netWorthValue,
        assets,
        graphData,
        graphGap,
        performance,
        performancePerc,
      ];
}
