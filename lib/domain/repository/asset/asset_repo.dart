import 'package:flutter/material.dart';
import 'package:net_worth_manager/models/obox/asset_history_time_value.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';

import '../../../models/obox/asset_category_obox.dart';
import '../../../models/obox/asset_obox.dart';

abstract class AssetRepo {
  void saveAsset(Asset asset);

  void saveAssetPosition(AssetTimeValue position, Asset asset);

  void updatePosition(AssetTimeValue position);

  void deleteAsset(Asset asset);

  void deleteCategory(AssetCategory category);

  void deletePosition(Asset asset, AssetTimeValue timeValue);

  List<AssetCategory> getAssetCategories({
    bool onlyMarketAssetCat = false,
    bool onlyManualAssetCat = false,
  });

  List<Asset> getAssets();

  List<Asset> getAssetsFromCategory(AssetCategory category);

  double getValueAtDateTime(Asset asset, DateTime dateTime);

  void saveMarketValue(MarketInfo info);

  List<AssetHistoryTimeValue> getValueHistoryBySymbol(
      MarketInfo marketInfo, DateTime startDate);

  Future<double?> checkShareSplit(
      BuildContext context, String symbol, AssetTimeValue position);

  Future<Map<AssetTimeValue, double>?> checkShareSplitMultiPositions(
      BuildContext context, String symbol, List<AssetTimeValue> positions);
}
