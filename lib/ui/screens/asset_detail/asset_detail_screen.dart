import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_bloc.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_event.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_state.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/components/asset_detail_history_item.dart';

import '../../../domain/repository/alphaVantage/AlphaVantageRepImp.dart';
import '../../../domain/repository/asset/asset_repo_impl.dart';
import '../../../models/obox/asset_obox.dart';
import '../../widgets/graph/line_graph.dart';
import '../../widgets/graph/simple_asset_line_graph.dart';
import '../add_asset_position/add_asset_position_screen_params.dart';

class AssetDetailScreen extends StatelessWidget {
  static const route = "/AssetDetailScreen";

  Asset asset;

  AssetDetailScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AssetRepoImpl>(
              create: (context) => AssetRepoImpl()),
          RepositoryProvider<AlphaVantageRepImp>(
              create: (context) => AlphaVantageRepImp()),
        ],
        child: BlocProvider(
          create: (context) => AssetDetailBloc(
            asset,
            context.read<AssetRepoImpl>(),
            context.read<AlphaVantageRepImp>(),
          )..add(FetchGraphDataEvent()),
          child: BlocBuilder<AssetDetailBloc, AssetDetailState>(
            builder: (BuildContext context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(state.asset.name),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.screenMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Current value"),
                          Text(
                            state.asset.getCurrentValueWithCurrency(),
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (state.asset.marketInfo.target == null)
                            SimpleAssetLineGraph(
                              asset: state.asset,
                              graphData: state.graphData,
                            ),
                          if (state.asset.marketInfo.target != null) ...[
                            const SizedBox(height: Dimensions.m),
                            LineGraph(
                              showGapSelection: true,
                              asset: state.asset,
                              graphData: state.graphData,
                            ),
                          ],
                          const SizedBox(height: Dimensions.m),
                          Row(
                            children: [
                              Text(
                                "Value history",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                  onPressed: () async {
                                    await context.push(
                                      AddAssetPositionScreen.route,
                                      extra: AddAssetPositionScreenParams(
                                          asset: state.asset),
                                    );
                                    context
                                        .read<AssetDetailBloc>()
                                        .add(FetchGraphDataEvent());
                                  },
                                  icon: const Icon(Icons.add))
                            ],
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var timeValue = state.asset
                                    .getTimeValuesChronologicalOrder(
                                        latestFirst: true)[index];
                                return AssetDetailHistoryItem(
                                  state.asset,
                                  timeValue,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: state.asset.timeValues.length)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
