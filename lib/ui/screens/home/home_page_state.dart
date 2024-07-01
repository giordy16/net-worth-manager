import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
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
    this.performance,
    this.performancePerc,
    this.graphGap
  }) {
    graphGap = GetIt.I<Settings>().homeGraphIndex == null
        ? GraphTime.all
        : GraphTime.values[GetIt.I<Settings>().homeGraphIndex!];
  }

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
