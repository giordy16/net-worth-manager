import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';

import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import 'asset_repo.dart';

class AssetRepoImpl implements AssetRepo {
  @override
  double getNetWorth() {
    var value = 0.0;
    var allAssets = objectbox.store.box<Asset>().getAll();
    for (var asset in allAssets) {
      value = value + asset.getCurrentValue();
    }

    return value;
  }

  @override
  void saveAsset(Asset asset) {
    objectbox.store.box<Asset>().put(asset);
  }

  @override
  List<AssetCategory> getAssetCategories() {
    return objectbox.store
        .box<AssetCategory>()
        .query(AssetCategory_.userCanSelect.equals(true))
        .build()
        .find();
  }

  @override
  List<Asset> getAssets() {
    return objectbox.store.box<Asset>().getAll();
  }

  @override
  void saveAssetPosition(AssetTimeValue position, Asset asset) {
    objectbox.store.box<AssetTimeValue>().put(position);
    saveAsset(asset);
  }

  @override
  void deleteAsset(Asset asset) {
    for (var timeValue in asset.timeValues.toList()) {
      deletePosition(asset, timeValue);
    }
    objectbox.store.box<Asset>().remove(asset.id);
  }

  @override
  void deletePosition(Asset asset, AssetTimeValue timeValue) {
    objectbox.store.box<AssetTimeValue>().remove(timeValue.id);
    asset.timeValues.remove(timeValue);
  }

  @override
  void deleteCategory(AssetCategory category) {
    var assets = getAssetFromCategory(category);
    for (var asset in assets) {
      deleteAsset(asset);
    }

    if(category.userCanSelect) {
      objectbox.store.box<AssetCategory>().remove(category.id);
    }
  }

  @override
  void updatePosition(AssetTimeValue position, Asset asset) {
    objectbox.store.box<AssetTimeValue>().put(position);
  }

  @override
  List<Asset> getAssetFromCategory(AssetCategory category) {
    return objectbox.store
        .box<Asset>()
        .query(Asset_.category.equals(category.id))
        .build()
        .find();
  }

  @override
  void saveMarketValue(MarketInfo info) {
    objectbox.store.box<MarketInfo>().put(info);
  }

}
