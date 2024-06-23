import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'package:net_worth_manager/ui/screens/add_category/add_category_screen.dart';
import 'package:net_worth_manager/ui/screens/add_custom_pie/add_custom_pie_screen.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_screen_params.dart';
import 'package:net_worth_manager/ui/screens/add_market_asset/add_market_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_selection/add_selection_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_screen.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_params.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_screen.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_screen.dart';
import 'package:net_worth_manager/ui/screens/import_investments/import_investments_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/full_asset_allocation_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_screen.dart';
import 'package:net_worth_manager/ui/screens/settings/settings_page.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_screen.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>();
final _shellNavigatorBKey = GlobalKey<NavigatorState>();
final _shellNavigatorCKey = GlobalKey<NavigatorState>();

final appRoutes = GoRouter(
  initialLocation: HomePage.route,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            GoRoute(
                path: HomePage.route,
                pageBuilder: (context, state) => NoTransitionPage(
                      child: HomePage(),
                    ),
                routes: [
                  GoRoute(
                    path: AssetDetailScreen.route,
                    builder: (context, state) => AssetDetailScreen(
                      asset: state.extra as Asset,
                    ),
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            GoRoute(
                path: InsightsScreen.route,
                pageBuilder: (context, state) => NoTransitionPage(
                      child: InsightsScreen(),
                    ),
                routes: [
                  GoRoute(
                    path: FullAssetAllocationScreen.route,
                    builder: (context, state) => FullAssetAllocationScreen(),
                  ),
                  GoRoute(
                    path: AddCustomPieScreen.route,
                    builder: (context, state) => AddCustomPieScreen(),
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            GoRoute(
              path: SettingsScreen.route,
              pageBuilder: (context, state) => NoTransitionPage(
                child: SettingsScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AddAssetScreen.route,
      builder: (context, state) => AddAssetScreen(
        asset: state.extra as Asset?,
      ),
    ),
    GoRoute(
      path: CurrencySelectionScreen.route,
      builder: (context, state) =>
          CurrencySelectionScreen(state.extra as CurrencySelectionParams),
    ),
    GoRoute(
      path: AddSelectionScreen.route,
      builder: (context, state) => const AddSelectionScreen(),
    ),
    GoRoute(
      path: AddAssetCategory.route,
      builder: (context, state) => AddAssetCategory(
        category: state.extra as AssetCategory?,
      ),
    ),
    GoRoute(
      path: AddAssetPositionScreen.route,
      builder: (context, state) => LoadingOverlay(
        child: AddAssetPositionScreen(
          params: state.extra as AddAssetPositionScreenParams,
        ),
      ),
    ),
    GoRoute(
      path: TickerSearchScreen.route,
      builder: (context, state) => TickerSearchScreen(),
    ),
    GoRoute(
      path: AddMarketAssetScreen.route,
      builder: (context, state) => LoadingOverlay(
          child:
              AddMarketAssetScreen(state.extra as AddMarketAssetScreenParams)),
    ),
    GoRoute(
      path: ImportInvestmentsScreen.route,
      builder: (context, state) =>
          LoadingOverlay(child: ImportInvestmentsScreen()),
    ),
  ],
);
