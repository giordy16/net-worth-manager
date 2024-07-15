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
import 'package:net_worth_manager/ui/screens/firebase_contacts/firebase_contacts_screen.dart';
import 'package:net_worth_manager/ui/screens/general_selection/general_selection.dart';
import 'package:net_worth_manager/ui/screens/general_selection/general_selection_params.dart';
import 'package:net_worth_manager/ui/screens/import_export/import_export_screen.dart';
import 'package:net_worth_manager/ui/screens/import_investments/import_investments_screen.dart';
import 'package:net_worth_manager/ui/screens/full_asset_allocation/full_asset_allocation_screen.dart';
import 'package:net_worth_manager/ui/screens/manage_categories/manage_categories.dart';
import 'package:net_worth_manager/ui/screens/onboarding/onboarding_screen.dart';
import 'package:net_worth_manager/ui/screens/push_notification/push_notification_screen.dart';
import 'package:net_worth_manager/ui/screens/sell_position/sell_position_screen.dart';
import 'package:net_worth_manager/ui/screens/soon_available/soon_available_screen.dart';
import 'package:net_worth_manager/ui/screens/ticker_search/ticker_search_screen.dart';
import 'package:net_worth_manager/ui/widgets/modal/loading_overlay.dart';

final appRoutes = GoRouter(
    initialLocation: ScaffoldWithBottomNavigation.path,
    routes: [
      GoRoute(
        path: ScaffoldWithBottomNavigation.path,
        builder: (context, state) =>
            const LoadingOverlay(child: ScaffoldWithBottomNavigation()),
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
        builder: (context, state) => LoadingOverlay(
          child: AssetDetailScreen(
            asset: state.extra as Asset,
          ),
        ),
      ),
      GoRoute(
        path: TickerSearchScreen.route,
        builder: (context, state) => const TickerSearchScreen(),
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
            const LoadingOverlay(child: ImportInvestmentsScreen()),
      ),
      GoRoute(
        path: FullAssetAllocationScreen.route,
        builder: (context, state) => const FullAssetAllocationScreen(),
      ),
      GoRoute(
        path: AddCustomPieScreen.route,
        builder: (context, state) =>
            AddCustomPieScreen(state.extra as CustomPie?),
      ),
      GoRoute(
        path: ImportExportScreen.path,
        builder: (context, state) =>
            const LoadingOverlay(child: ImportExportScreen()),
      ),
      GoRoute(
        path: OnboardingScreen.path,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: HiddenAssetScreen.path,
        builder: (context, state) => const HiddenAssetScreen(),
      ),
      GoRoute(
          path: SellPositionScreen.path,
          builder: (context, state) => LoadingOverlay(
              child: SellPositionScreen(
                  state.extra as AddAssetPositionScreenParams))),
      GoRoute(
          path: FirebaseContactsScreen.path,
          builder: (context, state) => LoadingOverlay(
              child:
                  FirebaseContactsScreen(state.extra as FirebaseScreenType))),
      GoRoute(
          path: ManageCategories.path,
          builder: (context, state) => LoadingOverlay(
              child:
                  ManageCategories(state.extra as ManageCategoriesViewType?))),
      GoRoute(
        path: GeneralSelection.path,
        builder: (context, state) =>
            GeneralSelection(state.extra as GeneralSelectionParams),
      ),
      GoRoute(
          path: SoonAvailableScreen.path,
          builder: (context, state) => const SoonAvailableScreen()),
      GoRoute(
          path: PushNotificationScreen.route,
          builder: (context, state) => PushNotificationScreen()),
    ],
    redirect: (context, state) {
      if (GetIt.I<Settings>().showTutorial == true &&
          state.fullPath != CurrencySelectionScreen.route) {
        return OnboardingScreen.path;
      }
      return null;
    });
