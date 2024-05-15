import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_screen.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_bloc.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_event.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../main.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../utils/TextStyles.dart';
import '../add_category/add_category_screen.dart';
import '../add_selection/add_selection_screen.dart';
import 'components/home_page_category.dart';
import 'home_page_state.dart';

class HomePage extends StatelessWidget {
  static const route = "/";

  const HomePage({super.key});

  Future<void> onShowMoreCategory(
      BuildContext context, AssetCategory category) async {
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
        await context.push(AddAssetCategory.route, extra: category);
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
        if ((await showDeleteConfirmSheet(context,
                "Are you sure you want to delete this category? All its asset and positions will be deleted")) ==
            true) {
          context.read<HomePageBloc>().add(DeleteCategory(category));
          context.read<HomePageBloc>().add(FetchHomePage());
        }
      }
    });

    var selectedOption =
        await showSelectionSheet(context, selections.keys.toList());
    selections[selectedOption]?.call();
  }

  Future<void> onAssetLongPress(
    BuildContext context,
    Asset asset,
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
        await context.push(AddAssetScreen.route, extra: asset);
        if (!context.mounted) return;
        context.read<HomePageBloc>().add(FetchHomePage());
        context.read<HomePageBloc>().add(FetchHomePage());
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
        if ((await showDeleteConfirmSheet(context)) == true) {
          context.read<HomePageBloc>().add(DeleteAsset(asset));
          context.read<HomePageBloc>().add(FetchHomePage());
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

    return RepositoryProvider(
      create: (_) => AssetRepoImpl(),
      child: BlocProvider(
        create: (context) => HomePageBloc(
          assetRepo: context.read<AssetRepoImpl>(),
        )..add(FetchHomePage()),
        child:
            BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
          Settings settings = objectbox.store.box<Settings>().getAll().first;

          List<AssetCategory> categories = (state.assets ?? [])
              .map((e) => e.category.target)
              .nonNulls
              .toSet()
              .toList();

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
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.screenMargin),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.cardCorner),
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.m),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your net worth:',
                                style: normalBoldTextTS().copyWith(
                                    color: theme.colorScheme.onSecondary),
                              ),
                              Text(
                                "${settings.defaultCurrency.target?.symbol} ${(state.netWorthValue ?? 0).toStringFormatted()}",
                                style: normalTextTS().copyWith(
                                    color: theme.colorScheme.onSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.l),
                      ListView.separated(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var category = categories.toList()[index];
                          var assetsOfCategory = state.assets
                                  ?.where((element) =>
                                      element.category.target == category)
                                  .toList() ??
                              [];

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
                            onLongPress: (asset) =>
                                onAssetLongPress(context, asset),
                            onMoreClick: (category) =>
                                onShowMoreCategory(context, category),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: Dimensions.l);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
