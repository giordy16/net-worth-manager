import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
import '../../../app_images.dart';
import '../../../models/obox/net_worth_history.dart';
import '../../../objectbox.g.dart';
import '../../widgets/modal/bottom_sheet.dart';
import 'insights_cubit.dart';

class InsightsScreen extends StatelessWidget {
  static String route = "/InsightsScreen";

  Future<void> onShowMoreAllocation(
    BuildContext context,
    CustomPie customAllocation,
  ) async {
    Map<Widget, Function> selections = {};

    selections.addAll({
      const Row(
        children: [
          Icon(Icons.edit),
          SizedBox(
            width: 4,
          ),
          Text("Edit")
        ],
      ): () async {
        await context
            .push(AddCustomPieScreen.route, extra: customAllocation);
        context
            .read<InsightsCubit>()
            .initCustomAllocationChart();
      }
    });

    selections.addAll({
      const Row(
        children: [
          Icon(Icons.delete_outlined),
          SizedBox(
            width: 4,
          ),
          Text("Delete")
        ],
      ): () async {
        if ((await showDeleteConfirmSheet(
                context, "Are you sure you want to delete this chart?")) ==
            true) {
          context
              .read<InsightsCubit>()
              .deleteCustomAllocationChart(customAllocation.id);
        }
      }
    });

    var selectedOption =
        await showSelectionSheet(context, selections.keys.toList());
    selections[selectedOption]?.call();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                      if (state.categoryAllocationData?.isEmpty == true) {
                        // there are no assets with > 0, build empty UI
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppImages.addData,
                                  width: 50,
                                  height: 50,
                                  colorFilter: ColorFilter.mode(
                                    theme.colorScheme.secondary,
                                    BlendMode.srcIn,
                                  )),
                              const SizedBox(height: Dimensions.l),
                              Text(
                                "You have not registered any assets yet.\n\nAdd your assets in the Home to have the insights.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
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
                                  onPressed: () async {
                                    await context
                                        .push(AddCustomPieScreen.route);
                                    context
                                        .read<InsightsCubit>()
                                        .initCustomAllocationChart();
                                  },
                                  icon: Icon(Icons.add),
                                )
                              ],
                            ),
                            AllocationPieChart(state.categoryAllocationData),
                            const SizedBox(height: Dimensions.xl),
                            if (state.customAllocationData?.isNotEmpty == true)
                              ...state.customAllocationData!
                                  .map((element) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                element.name,
                                                style: theme
                                                    .textTheme.titleLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  await onShowMoreAllocation(
                                                    context,
                                                    element,
                                                  );
                                                },
                                                icon: Icon(Icons.more_vert),
                                              )
                                            ],
                                          ),
                                          AllocationPieChart(
                                              element.getChartData()),
                                          const SizedBox(height: Dimensions.xl),
                                        ],
                                      )),
                            // IconButton(
                            //     padding: EdgeInsets.zero,
                            //     onPressed: () => context
                            //         .push(FullAssetAllocationScreen.route),
                            //     icon: Row(children: [
                            //       Text(
                            //         "See full asset allocation",
                            //         style: theme.textTheme.bodyLarge,
                            //       ),
                            //       const Expanded(child: SizedBox()),
                            //       const Icon(Icons.arrow_forward_ios, size: 14)
                            //     ])),
                            const SizedBox(height: Dimensions.l),
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
                            GainLossesChart(
                                state.gainLossData,
                                state.startDateGainGraph,
                                state.endDateGainGraph)
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            )),
      ),
    );
  }
}
