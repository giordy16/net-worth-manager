import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';

import '../../../models/obox/asset_obox.dart';
import 'asset_repo.dart';

class AssetRepoImpl implements AssetRepo {
  @override
  double getCurrentNetWorth() {
    var value = 0.0;
    var allAssets = objectbox.store.box<Asset>().getAll();
    for (var asset in allAssets) {
      value = value + (asset.getLastValue() ?? 0);
    }

    return value;
  }

  @override
  void saveNewAsset(Asset asset) {
    objectbox.store.box<Asset>().put(asset);
  }

  @override
  List<AssetCategory> getAssetCategories() {
    return objectbox.store.box<AssetCategory>().getAll();
  }

  @override
  List<Asset> getAssets() {
    return objectbox.store.box<Asset>().getAll();
  }

  @override
  void saveNewAssetPosition(AssetTimeValue position, Asset asset) {
    objectbox.store.box<AssetTimeValue>().put(position);
    asset.timeValues.add(position);
    saveNewAsset(asset);
  }
}
