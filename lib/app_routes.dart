import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/models/obox/custom_pie_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
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
import 'package:net_worth_manager/ui/screens/excluded_asset/excluded_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/import_export/import_export_screen.dart';
import 'package:net_worth_manager/ui/screens/import_investments/import_investments_screen.dart';
import 'package:net_worth_manager/ui/screens/full_asset_allocation/full_asset_allocation_screen.dart';
import 'package:net_worth_manager/ui/screens/onboarding/onboarding_screen.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_screen.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';
import 'package:path/path.dart';

final appRoutes = GoRouter(
    initialLocation: ScaffoldWithBottomNavigation.path,
    routes: [
      GoRoute(
        path: ScaffoldWithBottomNavigation.path,
        builder: (context, state) =>
            LoadingOverlay(child: ScaffoldWithBottomNavigation()),
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
        path: AssetDetailScreen.route,
        builder: (context, state) => AssetDetailScreen(
          asset: state.extra as Asset,
        ),
      ),
      GoRoute(
        path: TickerSearchScreen.route,
        builder: (context, state) => TickerSearchScreen(),
      ),
      GoRoute(
        path: AddMarketAssetScreen.route,
        builder: (context, state) => LoadingOverlay(
            child: AddMarketAssetScreen(
                state.extra as AddMarketAssetScreenParams)),
      ),
      GoRoute(
        path: ImportInvestmentsScreen.route,
        builder: (context, state) =>
            LoadingOverlay(child: ImportInvestmentsScreen()),
      ),
      GoRoute(
        path: FullAssetAllocationScreen.route,
        builder: (context, state) => FullAssetAllocationScreen(),
      ),
      GoRoute(
        path: AddCustomPieScreen.route,
        builder: (context, state) =>
            AddCustomPieScreen(state.extra as CustomPie?),
      ),
      GoRoute(
        path: ImportExportScreen.path,
        builder: (context, state) =>
            LoadingOverlay(child: ImportExportScreen()),
      ),
      GoRoute(
        path: OnboardingScreen.path,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: HiddenAssetScreen.path,
        builder: (context, state) => HiddenAssetScreen(),
      ),
    ],
    redirect: (context, state) {
      if (GetIt.I<Settings>().showTutorial == true) {
        return OnboardingScreen.path;
      }
      return null;
    });
