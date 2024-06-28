import 'package:equatable/equatable.dart';

import '../../widgets/graph/allocation_pie_chart.dart';
import '../../widgets/graph/gain_losses_chart.dart';

class InsightsState extends Equatable {
  final List<PieChartData>? categoryAllocationData;
  final List<ColumnGraphData>? gainLossData;
  final bool loading;

  InsightsState({
    required this.categoryAllocationData,
    required this.gainLossData,
    required this.loading,
  });

  InsightsState.initial({
    this.categoryAllocationData,
    this.gainLossData,
    this.loading = false,
  });

  InsightsState copyWith(
      {List<PieChartData>? categoryAllocationData,
      List<ColumnGraphData>? gainLossData,
      bool? loading}) {
    return InsightsState(
      categoryAllocationData:
          categoryAllocationData ?? this.categoryAllocationData,
      gainLossData: gainLossData ?? this.gainLossData,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [categoryAllocationData, gainLossData, loading];
}
