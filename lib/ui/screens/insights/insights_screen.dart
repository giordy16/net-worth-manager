import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/custom_pie_obox.dart';
import 'package:net_worth_manager/ui/screens/add_custom_pie/add_custom_pie_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_state.dart';
import 'package:net_worth_manager/ui/widgets/graph/allocation_pie_chart.dart';
import 'package:net_worth_manager/ui/widgets/graph/gain_losses_chart.dart';

import '../../../app_dimensions.dart';
import '../../../app_images.dart';
import '../../../i18n/strings.g.dart';
import '../../widgets/modal/bottom_sheet.dart';
import 'insights_cubit.dart';

class InsightsScreen extends StatefulWidget {
  static String route = "/InsightsScreen";

  static bool shouldUpdatePage = true;

  const InsightsScreen({super.key});

  @override
  State<StatefulWidget> createState() => InsightsScreenState();
}

class InsightsScreenState extends State<InsightsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  initState() {
    if (GetIt.I.isRegistered(instance: this)) {
      GetIt.I.unregister(instance: this);
    } else {
      GetIt.I.registerSingleton<InsightsScreenState>(this);
    }

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    if (GetIt.I.isRegistered(instance: this)) {
      GetIt.I.unregister(instance: this);
    }
  }

  Future<void> onShowMoreAllocation(
    BuildContext context,
    CustomPie customAllocation,
  ) async {
    Map<Widget, Function> selections = {};

    selections.addAll({
      Row(
        children: [
          const Icon(Icons.edit),
          const SizedBox(
            width: 4,
          ),
          Text(t.edit_name)
        ],
      ): () async {
        await context.push(AddCustomPieScreen.route, extra: customAllocation);
        context.read<InsightsCubit>().initCustomAllocationChart();
      }
    });

    selections.addAll({
      Row(
        children: [
          const Icon(Icons.delete_outlined),
          const SizedBox(
            width: 4,
          ),
          Text(t.delete)
        ],
      ): () async {
        if ((await showDeleteConfirmSheet(context, t.delete_chart_message)) ==
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
    super.build(context);

    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.screenMargin),
                      child: Center(
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
                              t.insights_empty,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: Dimensions.screenMargin),
                              child: Text(
                                t.allocation,
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                await context.push(AddCustomPieScreen.route);
                                context
                                    .read<InsightsCubit>()
                                    .initCustomAllocationChart();
                              },
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.screenMargin),
                          child:
                              AllocationPieChart(state.categoryAllocationData),
                        ),
                        const SizedBox(height: Dimensions.xl),
                        if (state.customAllocationData?.isNotEmpty == true)
                          ...state.customAllocationData!.map((element) =>
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: Dimensions.screenMargin),
                                        child: Text(
                                          element.name,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
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
                                        icon: const Icon(Icons.more_vert),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.screenMargin),
                                    child: AllocationPieChart(
                                        element.getChartData()),
                                  ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.screenMargin),
                          child: Text(
                            t.monthly_gain_loss,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
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
                                        .changeEndGainGraph();
                                  },
                                  child: Text(DateFormat("MMM yy")
                                      .format(state.endDateGainGraph!))),
                            ],
                          ),
                        const SizedBox(height: Dimensions.s),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.screenMargin),
                          child: GainLossesChart(state.gainLossData,
                              state.startDateGainGraph, state.endDateGainGraph),
                        ),
                        const SizedBox(height: Dimensions.xl)
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    bool val = InsightsScreen.shouldUpdatePage;
    InsightsScreen.shouldUpdatePage = false;
    return !val;
  }
}
