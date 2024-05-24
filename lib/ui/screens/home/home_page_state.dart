import 'package:equatable/equatable.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../models/ui/graph_data.dart';

class HomePageState extends Equatable {
  final double? netWorthValue;
  final List<Asset>? assets;
  final List<GraphData>? graphData;

  const HomePageState({
    this.netWorthValue,
    this.assets,
    this.graphData,
  });

  HomePageState copyWith({
    double? netWorthValue,
    List<Asset>? assets,
    List<GraphData>? graphData,
  }) {
    return HomePageState(
      netWorthValue: netWorthValue ?? this.netWorthValue,
      assets: assets ?? this.assets,
      graphData: graphData ?? this.graphData,
    );
  }

  @override
  List<Object?> get props => [netWorthValue, assets, graphData];
}
