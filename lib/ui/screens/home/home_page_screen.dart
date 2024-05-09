import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_dimensions.dart';
import 'package:net_worth_manager/domain/repository/asset/asset_repo_impl.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_screen.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_bloc.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_event.dart';

import '../../../main.dart';
import '../../../utils/TextStyles.dart';
import '../add_asset/add_asset_screen.dart';
import 'components/home_page_category.dart';
import 'home_page_state.dart';

class HomePage extends StatelessWidget {
  static const route = "/";

  const HomePage({super.key});

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
                await context.push(AddAssetScreen.route);
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
                                "${settings.defaultCurrency.target?.symbol} ${state.netWorthValue ?? "-"}",
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