import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:net_worth_manager/utils/extensions/objectbox_extension.dart';

import '../../../models/obox/asset_history_time_value.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import 'asset_repo.dart';

class AssetRepoImpl implements AssetRepo {
  @override
  void saveAsset(Asset asset) {
    GetIt.I<Store>().box<Asset>().put(asset);
  }

  @override
  List<AssetCategory> getAssetCategories() {
    return GetIt.I<Store>()
        .box<AssetCategory>()
        .query(AssetCategory_.userCanSelect.equals(true))
        .build()
        .find();
  }

  @override
  List<Asset> getAssets() {
    return GetIt.I<Store>().box<Asset>().getAll();
  }

  @override
  void saveAssetPosition(AssetTimeValue position, Asset asset) {
    if (position.id == 0) {
      // new position
      asset.timeValues.add(position);
      saveAsset(asset);
    } else {
      // update position
      updatePosition(position);
    }
  }

  @override
  void deleteAsset(Asset asset) {
    for (var timeValue in asset.timeValues.toList()) {
      deletePosition(asset, timeValue);
    }
    GetIt.I<Store>().box<Asset>().remove(asset.id);
  }

  @override
  void deletePosition(Asset asset, AssetTimeValue timeValue) {
    GetIt.I<Store>().box<AssetTimeValue>().remove(timeValue.id);
    asset.timeValues.remove(timeValue);
  }

  @override
  void deleteCategory(AssetCategory category) {
    var assets = getAssetsFromCategory(category);
    for (var asset in assets) {
      deleteAsset(asset);
    }

    if (category.userCanSelect) {
      GetIt.I<Store>().box<AssetCategory>().remove(category.id);
    }
  }

  @override
  void updatePosition(AssetTimeValue position) {
    GetIt.I<Store>().box<AssetTimeValue>().put(position);
  }

  @override
  List<Asset> getAssetsFromCategory(AssetCategory category) {
    return GetIt.I<Store>()
        .box<Asset>()
        .query(Asset_.category.equals(category.id))
        .build()
        .find();
  }

  @override
  Future<void> saveMarketValue(MarketInfo info) async {
    GetIt.I<Store>().box<MarketInfo>().put(info);
    await GetIt.I<Store>().syncForexPrices();
  }

  /// Returning the value of the @asset at the specified @dateTime at the mainCurrency
  @override
  double getValueAtDateTime(Asset asset, DateTime dateTime) {
    if (asset.marketInfo.target == null) {
      // simple asset
      AssetTimeValue? lastTimeValue = asset
          .getTimeValuesChronologicalOrder()
          .where((element) =>
              element.date.isBefore(dateTime.add(const Duration(days: 1))))
          .lastOrNull;

      return lastTimeValue?.getCurrentValue(date: dateTime) ?? 0;
    } else {
      // market asset

      int i = 0;
      double marketValueAtTime = 0;
      final assetHistoryTimeValueBox =
          GetIt.I<Store>().box<AssetHistoryTimeValue>();

      while (marketValueAtTime == 0) {
        marketValueAtTime = assetHistoryTimeValueBox
                .query(AssetHistoryTimeValue_.assetName
                        .equals(asset.marketInfo.target!.symbol) &
                    AssetHistoryTimeValue_.date
                        .equalsDate(dateTime.subtract(Duration(days: i))))
                .build()
                .findFirst()
                ?.value ??
            0;
        i++;
      }

      return (marketValueAtTime * asset.getQuantityAtDateTime(dateTime))
          .atMainCurrency(
        fromCurrency: asset.marketInfo.target!.currency,
        dateTime: dateTime,
      );
    }
  }

  @override
  List<AssetHistoryTimeValue> getValueHistoryBySymbol(
      MarketInfo marketInfo, DateTime startDate) {
    final historyBox = GetIt.I<Store>().box<AssetHistoryTimeValue>();
    return historyBox
        .query(AssetHistoryTimeValue_.assetName.equals(marketInfo.symbol) &
            AssetHistoryTimeValue_.date.greaterOrEqualDate(startDate))
        .order(AssetHistoryTimeValue_.date)
        .build()
        .find();
  }
}
