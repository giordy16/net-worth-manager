import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/domain/repository/net_worth/net_worth_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_screen.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_bloc.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_event.dart';
import 'package:net_worth_manager/ui/screens/manage_categories/manage_categories.dart';
import 'package:net_worth_manager/ui/widgets/base_components/performance_text.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';
import 'package:net_worth_manager/utils/enum/graph_data_gap_enum.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../app_images.dart';
import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../widgets/graph/line_graph.dart';
import '../add_category/add_category_screen.dart';
import '../add_selection/add_selection_screen.dart';
import 'components/home_page_category.dart';
import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  static const route = "/HomePage";

  static bool shouldUpdatePage = true;

  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  initState() {
    if (GetIt.I.isRegistered(instance: this)) {
      GetIt.I.unregister(instance: this);
    } else {
      GetIt.I.registerSingleton<HomePageScreenState>(this);
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

  Future<void> onShowMoreCategory(
      BuildContext context, AssetCategory category) async {
    Map<Widget, Function> selections = {};

    selections.addAll({
      Row(
        children: [
          Icon(Icons.edit),
          SizedBox(
            width: 4,
          ),
          Text(t.edit_name)
        ],
      ): () async {
        await context.push(AddAssetCategory.route, extra: category);
        context.read<HomePageBloc>().add(FetchHomePage());
        ScaffoldWithBottomNavigation.updateScreens();
      }
    });

    selections.addAll({
      Row(
        children: [
          const Icon(Icons.swap_vert),
          const SizedBox(
            width: 4,
          ),
          Text(t.reorder)
        ],
      ): () async {
        await context.push(ManageCategories.path, extra: ManageCategoriesViewType.reorder);
        context.read<HomePageBloc>().add(FetchHomePage());
        ScaffoldWithBottomNavigation.updateScreens();
      }
    });

    if (category.userCanSelect) {
      selections.addAll({
        Row(
          children: [
            Icon(Icons.delete_outlined),
            SizedBox(
              width: 4,
            ),
            Text(t.delete)
          ],
        ): () async {
          if ((await showDeleteConfirmSheet(
                  context, t.delete_confirmation_category)) ==
              true) {
            context.read<HomePageBloc>().add(DeleteCategory(category));
          }
        }
      });
    }

    var selectedOption =
        await showSelectionSheet(context, selections.keys.toList());
    selections[selectedOption]?.call();
  }

  Future<void> onAssetLongPress(
    BuildContext context,
    Asset asset,
  ) async {
    Map<Widget, Function> selections = {};

    if (asset.marketInfo.target == null) {
      // only for simple asset
      selections.addAll({
        Row(
          children: [
            Icon(Icons.edit),
            SizedBox(
              width: 4,
            ),
            Text(t.edit_name)
          ],
        ): () async {
          await context.push(AddAssetScreen.route, extra: asset);
          if (!context.mounted) return;
          context.read<HomePageBloc>().add(FetchHomePage());
          ScaffoldWithBottomNavigation.updateScreens();
        }
      });
    }

    selections.addAll({
      Row(
        children: [
          Icon(Icons.visibility_off),
          SizedBox(
            width: 4,
          ),
          Text(t.hide)
        ],
      ): () async {
        if ((await showDeleteConfirmSheet(context, t.hide_message)) == true) {
          context.read<HomePageBloc>().add(HideAsset(asset));
        }
      }
    });

    selections.addAll({
      Row(
        children: [
          Icon(Icons.delete_outlined),
          SizedBox(
            width: 4,
          ),
          Text(t.delete)
        ],
      ): () async {
        if ((await showDeleteConfirmSheet(
                context, t.delete_confirmation_asset)) ==
            true) {
          context.read<HomePageBloc>().add(DeleteAsset(asset));
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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AssetRepoImpl>(create: (context) => AssetRepoImpl()),
        RepositoryProvider<NetWorthRepoImpl>(
            create: (context) => NetWorthRepoImpl()),
      ],
      child: BlocProvider(
        create: (context) => HomePageBloc(
            context: context,
            assetRepo: context.read<AssetRepoImpl>(),
            netWorthRepo: context.read<NetWorthRepoImpl>())
          ..add(FetchHomePage()),
        child:
            BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.colorScheme.tertiaryContainer,
              onPressed: () async {
                await context.push(AddSelectionScreen.route);
                if (!context.mounted) return;
                context.read<HomePageBloc>().add(FetchHomePage());
              },
              child: Icon(
                Icons.add,
                color: theme.colorScheme.secondary,
              ),
            ),
            body: state.assets == null
                ? const Center(child: CircularProgressIndicator())
                : state.assets!.isEmpty
                    ? buildNoDataUI(context)
                    : buildUI(context, state),
          );
        }),
      ),
    );
  }

  Widget buildNoDataUI(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(Dimensions.screenMargin),
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
            Text(t.home_empty, textAlign: TextAlign.center),
          ],
        ),
      ),
    ));
  }

  Widget buildUI(BuildContext context, HomePageState state) {
    ThemeData theme = Theme.of(context);

    List<AssetCategory> categories = (state.assets ?? [])
        .map((e) => e.category.target)
        .nonNulls
        .toSet()
        .toList();

    categories.sort((a, b) => (a.order).compareTo(b.order));

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Dimensions.xs),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.your_net_worth),
                        Text(
                          (state.netWorthValue ?? 0).toStringWithCurrency(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.performance != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PerformanceText(
                            performance: state.performancePerc!,
                            textStyle: theme.textTheme.bodyMedium,
                            type: PerformanceTextType.percentage,
                          ),
                          PerformanceText(
                            performance: state.performance!,
                            textStyle: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.right,
                            type: PerformanceTextType.value,
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.m),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: LineGraph(
                showGapSelection: true,
                showLoading: state.graphData == null,
                graphData: state.graphData ?? [],
                initialGap: state.graphGap,
                onGraphTimeChange: (graphGap) {
                  context
                      .read<HomePageBloc>()
                      .add(FetchHomePage(gap: graphGap));
                },
              ),
            ),
            const SizedBox(height: Dimensions.m),
            ListView.separated(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var category = categories.toList()[index];
                var assetsOfCategory = state.assets
                        ?.where(
                            (element) => element.category.target == category)
                        .toList() ??
                    [];

                assetsOfCategory.sort((a, b) => a.name.compareTo(b.name));

                return HomePageCategory(
                  category: category,
                  assets: assetsOfCategory,
                  onItemClick: (asset) async {
                    await context.push(
                      AssetDetailScreen.route,
                      extra: asset,
                    );
                    context.read<HomePageBloc>().add(FetchHomePage());
                  },
                  onLongPress: (asset) => onAssetLongPress(context, asset),
                  onMoreClick: (category) =>
                      onShowMoreCategory(context, category),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: Dimensions.m);
              },
            ),
            const SizedBox(height: 56),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.screenMargin),
              child: Text(
                t.home_disclaimer,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 80)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    bool val = HomePage.shouldUpdatePage;
    HomePage.shouldUpdatePage = false;
    return !val;
  }
}
