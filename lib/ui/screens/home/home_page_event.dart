import 'package:net_worth_manager/models/obox/asset_category_obox.dart';

import '../../../models/obox/asset_obox.dart';

abstract class HomePageEvent {}

class FetchHomePage extends HomePageEvent {}

class DeleteAsset extends HomePageEvent {
  Asset asset;

  DeleteAsset(this.asset);
}

class DeleteCategory extends HomePageEvent {
  AssetCategory category;

  DeleteCategory(this.category);
}
