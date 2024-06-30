import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_state.dart';
import 'package:net_worth_manager/utils/background_thread.dart';

import '../../../domain/repository/net_worth/net_worth_repo.dart';
import '../../../models/obox/asset_category_obox.dart';
import '../../../models/obox/custom_pie_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/graph/allocation_pie_chart.dart';
import '../../widgets/graph/gain_losses_chart.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit({
    required this.context,
    required this.nwRepo,
  }) : super(InsightsState.initial()) {
    initPage();
  }

  NetWorthRepo nwRepo;
  BuildContext context;

  void initPage() {
    initCategoryAssetData();
    initCustomAllocationChart();
    initGainLossesData();

    emit(state.copyWith(loading: false));
  }

  void initCategoryAssetData() {
    final categories = GetIt.I<Store>()
        .box<AssetCategory>()
        .getAll()
        .where((cat) => cat.getValue() > 0)
        .toList();
    categories.sort((a, b) => b.getValue().compareTo(a.getValue()));

    var graphData = categories
        .map((cat) => PieChartData(
            cat.name,
            cat.getValue(),
            double.parse((cat.getValue() / nwRepo.getNetWorth() * 100)
                .toStringAsFixed(1))))
        .toList();

    emit(state.copyWith(categoryAllocationData: graphData));
  }

  Future<void> initGainLossesData() async {
    final nwAtTheEndOfMonths = await nwRepo.getNetWorthsAtTheEndOfMonths();

    List<ColumnGraphData> chartData = [];

    if (nwAtTheEndOfMonths.isEmpty) {
      emit(state.copyWith(gainLossData: chartData));
      return;
    }

    for (var i = 1; i < nwAtTheEndOfMonths.entries.length; i++) {
      var entry = nwAtTheEndOfMonths.entries.toList()[i];
      var entryPrevMonth = nwAtTheEndOfMonths.entries.toList()[i - 1];
      chartData.add(ColumnGraphData(
          DateFormat("MMM yy").format(entry.key),
          double.parse(
              (entry.value - entryPrevMonth.value).toStringAsFixed(2))));
    }

    if (chartData.isNotEmpty) {
      emit(state.copyWith(
          startDateGainGraph: GetIt.I<Settings>().startDateGainGraph ??
              DateFormat("MMM yy").parse(chartData.first.x)));

      emit(state.copyWith(
          endDateGainGraph: GetIt.I<Settings>().endDateGainGraph ??
              DateFormat("MMM yy").parse(chartData.last.x)));
    }
    emit(state.copyWith(gainLossData: chartData));
  }

  void initCustomAllocationChart() {
    final customPie = GetIt.I<Store>().box<CustomPie>().getAll();
    emit(state.copyWith(customAllocationData: customPie));
  }

  void deleteCustomAllocationChart(int id) {
    GetIt.I<Store>().box<CustomPie>().remove(id);
    initCustomAllocationChart();
  }

  Future<void> changeStartGainGraph() async {
    final settings = GetIt.I<Settings>();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.startDateGainGraph,
      firstDate: DateFormat("MMM yy").parse(state.gainLossData!.first.x),
      lastDate: DateFormat("MMM yy").parse(state.gainLossData!.last.x),
    );
    if (picked != null) {
      settings.startDateGainGraph = picked;
      GetIt.I<Store>().box<Settings>().put(settings);

      emit(state.copyWith(startDateGainGraph: picked));
    }
  }

  Future<void> changeEndGainGraph() async {
    final settings = GetIt.I<Settings>();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.endDateGainGraph,
      firstDate: DateFormat("MMM yy").parse(state.gainLossData!.first.x),
      lastDate: DateFormat("MMM yy").parse(state.gainLossData!.last.x),
    );
    if (picked != null) {
      settings.endDateGainGraph = picked;
      GetIt.I<Store>().box<Settings>().put(settings);

      emit(state.copyWith(endDateGainGraph: picked));
    }
  }
}
