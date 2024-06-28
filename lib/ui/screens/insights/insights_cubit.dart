import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_state.dart';
import 'package:net_worth_manager/utils/background_thread.dart';

import '../../../domain/repository/net_worth/net_worth_repo.dart';
import '../../../models/obox/asset_category_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/graph/allocation_pie_chart.dart';
import '../../widgets/graph/gain_losses_chart.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit(this.nwRepo) : super(InsightsState.initial()) {
    initPage();
  }

  NetWorthRepo nwRepo;

  void initPage() {
    initCategoryAssetData();
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
    print(DateTime.now());
    final nwAtTheEndOfMonths =
        await runInDifferentThread(() => nwRepo.getNetWorthsAtTheEndOfMonths());
    print(DateTime.now());

    List<ColumnGraphData> chartData = [];

    for (var i = 1; i < nwAtTheEndOfMonths.entries.length - 2; i++) {
      var entry = nwAtTheEndOfMonths.entries.toList()[i];
      var entryPrevMonth = nwAtTheEndOfMonths.entries.toList()[i - 1];
      chartData.add(ColumnGraphData(
          DateFormat("MMM yy").format(entry.key),
          double.parse(
              (entry.value - entryPrevMonth.value).toStringAsFixed(2))));
    }
    print(DateTime.now());

    emit(state.copyWith(gainLossData: chartData));
  }
}
