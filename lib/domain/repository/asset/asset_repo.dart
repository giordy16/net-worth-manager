import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../models/obox/asset_obox.dart';

abstract class AssetRepo {

  double getCurrentNetWorth();

  void saveNewAsset(Asset asset);
  void saveNewAssetPosition(AssetTimeValue position, Asset asset);
  void updatePosition(AssetTimeValue position, Asset asset);

  void deleteAsset(Asset asset);
  void deleteCategory(AssetCategory category);
  void deletePosition(Asset asset, AssetTimeValue timeValue);

  List<AssetCategory> getAssetCategories();
  List<Asset> getAssets();
  List<Asset> getAssetFromCategory(AssetCategory category);
}