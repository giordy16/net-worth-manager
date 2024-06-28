import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/custom_pie_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/add_custom_pie/add_custom_pie_screen.dart';
import 'package:net_worth_manager/ui/screens/full_asset_allocation/full_asset_allocation_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_state.dart';
import 'package:net_worth_manager/ui/widgets/graph/allocation_pie_chart.dart';
import 'package:net_worth_manager/ui/widgets/graph/gain_losses_chart.dart';
import 'package:net_worth_manager/utils/extensions/context_extensions.dart';

import '../../../app_dimensions.dart';
import '../../../models/obox/net_worth_history.dart';
import '../../../objectbox.g.dart';
import 'insights_cubit.dart';

class InsightsScreen extends StatelessWidget {
  static String route = "/InsightsScreen";

  Future<void> changeStartDateGainsGraph(BuildContext context) async {}

  Future<void> changeEndDateGainsGraph(BuildContext context) async {
    final settings = GetIt.I<Settings>();
    DateTime? end = settings.endDateGainGraph;

    DateTime firstNw = GetIt.I<Store>()
        .box<NetWorthHistory>()
        .query()
        .order(NetWorthHistory_.date)
        .build()
        .findFirst()!
        .date;

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: end ?? DateTime.now(),
        firstDate: firstNw,
        lastDate: DateTime.now());
    if (picked != null) {
      settings.endDateGainGraph = picked;
      GetIt.I<Store>().box<Settings>().put(settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final customPie = GetIt.I<Store>().box<CustomPie>().getAll();

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(Dimensions.screenMargin),
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider<NetWorthRepoImpl>(
                    create: (context) => NetWorthRepoImpl()),
              ],
              child: BlocProvider<InsightsCubit>(
                create: (context) => InsightsCubit(
                  context: context,
                  nwRepo: context.read<NetWorthRepoImpl>(),
                ),
                child: BlocBuilder<InsightsCubit, InsightsState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Allocation",
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => context.push(
                                    AddCustomPieScreen.route),
                                icon: Icon(Icons.add),
                              )
                            ],
                          ),
                          const SizedBox(height: Dimensions.s),
                          AllocationPieChart(state.categoryAllocationData),
                          const SizedBox(height: Dimensions.l),
                          ...customPie.map((element) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    element.name,
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: Dimensions.s),
                                  AllocationPieChart(element.getChartData()),
                                ],
                              )),
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  context.push(FullAssetAllocationScreen.route),
                              icon: Row(children: [
                                Text(
                                  "See full asset allocation",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const Expanded(child: SizedBox()),
                                const Icon(Icons.arrow_forward_ios, size: 14)
                              ])),
                          Text(
                            "Monthly Gains/Losses",
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: Dimensions.s),
                          if (state.startDateGainGraph != null &&
                              state.endDateGainGraph != null)
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      context
                                          .read<InsightsCubit>()
                                          .changeStartGainGraph();
                                    },
                                    child: Text(DateFormat("MMM yy")
                                        .format(state.startDateGainGraph!))),
                                const Text("-"),
                                TextButton(
                                    onPressed: () {
                                      context
                                          .read<InsightsCubit>()
                                          .changeStartGainGraph();
                                    },
                                    child: Text(DateFormat("MMM yy")
                                        .format(state.endDateGainGraph!))),
                              ],
                            ),
                          const SizedBox(height: Dimensions.s),
                          GainLossesChart(state.gainLossData,
                              state.startDateGainGraph, state.endDateGainGraph)
                        ],
                      );
                    }
                  },
                ),
              ),
            )),
      ),
    );
  }
}
