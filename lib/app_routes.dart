import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/models/obox/asset_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset/add_asset_screen.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen.dart';
import 'package:net_worth_manager/ui/screens/add_category/add_category_screen.dart';
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
      builder: (context, state) => AddAssetScreen(),
    ),
    GoRoute(
      path: CurrencySelectionScreen.route,
      builder: (context, state) => const CurrencySelectionScreen(),
    ),
    GoRoute(
      path: AddAssetCategory.route,
      builder: (context, state) => AddAssetCategory(),
    ),
    GoRoute(
      path: AddAssetPositionScreen.route,
      builder: (context, state) => AddAssetPositionScreen(
        asset: state.extra as Asset,
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
