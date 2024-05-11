import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';
import 'package:net_worth_manager/ui/screens/add_category/add_category_screen.dart';
import 'package:net_worth_manager/ui/screens/add_selection/add_selection_screen.dart';
import 'package:net_worth_manager/ui/screens/asset_detail/asset_detail_screen.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_screen.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_screen.dart';

final appRoutes = GoRouter(
  initialLocation: HomePage.route,
  routes: [
    GoRoute(
      path: HomePage.route,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AddAssetScreen.route,
      builder: (context, state) => AddAssetScreen(
        asset: state.extra as Asset?,
      ),
    ),
    GoRoute(
      path: CurrencySelectionScreen.route,
      builder: (context, state) => const CurrencySelectionScreen(),
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
      builder: (context, state) => AddAssetPositionScreen(
        params: state.extra as AddAssetPositionScreenParams,
      ),
    ),
    GoRoute(
      path: AssetDetailScreen.route,
      builder: (context, state) => AssetDetailScreen(
        asset: state.extra as Asset,
      ),
    ),
  ],
);
