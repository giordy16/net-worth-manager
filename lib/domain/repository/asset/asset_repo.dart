import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../models/obox/asset_obox.dart';

abstract class AssetRepo {

  double getNetWorth();

  void saveAsset(Asset asset);
  void saveAssetPosition(AssetTimeValue position, Asset asset);
  void updatePosition(AssetTimeValue position);

  void deleteAsset(Asset asset);
  void deleteCategory(AssetCategory category);
  void deletePosition(Asset asset, AssetTimeValue timeValue);

  List<AssetCategory> getAssetCategories();
  List<Asset> getAssets();
  List<Asset> getAssetFromCategory(AssetCategory category);

  void saveMarketValue(MarketInfo info);

}