import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/utils/enum/graph_data_gap_enum.dart';

import '../../../models/obox/asset_obox.dart';

abstract class HomePageEvent {}

class FetchHomePage extends HomePageEvent {
  GraphTime? gap;

  FetchHomePage({this.gap});
}

class DeleteAsset extends HomePageEvent {
  Asset asset;

  DeleteAsset(this.asset);
}

class HideAsset extends HomePageEvent {
  Asset asset;

  HideAsset(this.asset);
}

class DeleteCategory extends HomePageEvent {
  AssetCategory category;

  DeleteCategory(this.category);
}
