import 'package:equatable/equatable.dart';

import '../../widgets/graph/allocation_pie_chart.dart';
import '../../widgets/graph/gain_losses_chart.dart';

class InsightsState extends Equatable {
  final List<PieChartData>? categoryAllocationData;
  final List<ColumnGraphData>? gainLossData;
  final bool loading;
  final DateTime? startDateGainGraph;
  final DateTime? endDateGainGraph;

  InsightsState({
    required this.categoryAllocationData,
    required this.gainLossData,
    required this.loading,
    required this.startDateGainGraph,
    required this.endDateGainGraph,
  });

  InsightsState.initial({
    this.categoryAllocationData,
    this.gainLossData,
    this.loading = false,
    this.startDateGainGraph,
    this.endDateGainGraph,
  });

  InsightsState copyWith({
    List<PieChartData>? categoryAllocationData,
    List<ColumnGraphData>? gainLossData,
    bool? loading,
    DateTime? startDateGainGraph,
    DateTime? endDateGainGraph,
  }) {
    return InsightsState(
      categoryAllocationData:
          categoryAllocationData ?? this.categoryAllocationData,
      gainLossData: gainLossData ?? this.gainLossData,
      loading: loading ?? this.loading,
      startDateGainGraph: startDateGainGraph ?? this.startDateGainGraph,
      endDateGainGraph: endDateGainGraph ?? this.endDateGainGraph,
    );
  }

  @override
  List<Object?> get props => [
        categoryAllocationData,
        gainLossData,
        loading,
        startDateGainGraph,
        endDateGainGraph,
      ];
}
