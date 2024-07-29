import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/repository/stock/stock_api.dart';
import 'package:net_worth_manager/models/obox/asset_category_obox.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../i18n/strings.g.dart';
import '../../../models/obox/asset_history_time_value.dart';
import '../../../models/obox/asset_obox.dart';
import '../../../objectbox.g.dart';
import '../../../ui/widgets/modal/bottom_sheet.dart';
import 'asset_repo.dart';

class AssetRepoImpl implements AssetRepo {

  final StockApi? stockApi;

  AssetRepoImpl({this.stockApi});

  @override
  void saveAsset(Asset asset) {
    GetIt.I<Store>().box<Asset>().put(asset);
  }

  @override
  List<AssetCategory> getAssetCategories({
    bool onlyMarketAssetCat = false,
    bool onlyManualAssetCat = false,
  }) {
    var condition = onlyMarketAssetCat
        ? AssetCategory_.userCanSelect.equals(false)
        : onlyManualAssetCat
            ? AssetCategory_.userCanSelect.equals(true)
            : null;

    return GetIt.I<Store>()
        .box<AssetCategory>()
        .query(condition)
        .order(AssetCategory_.order)
        .build()
        .find();
  }

  @override
  List<Asset> getAssets() {
    return GetIt.I<Store>()
        .box<Asset>()
        .query()
        .order(Asset_.name)
        .build()
        .find();
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
      final assetHistoryTimeValueBox =
          GetIt.I<Store>().box<AssetHistoryTimeValue>();

      double marketValueAtTime = 0;

      List<AssetHistoryTimeValue> unsortedList = assetHistoryTimeValueBox
          .query(AssetHistoryTimeValue_.assetSymbol
                  .equals(asset.marketInfo.target!.symbol) &
              AssetHistoryTimeValue_.date.lessOrEqualDate(dateTime))
          .build()
          .find();

      unsortedList.sort((a, b) => b.date.compareTo(a.date));
      marketValueAtTime = unsortedList.firstOrNull?.value ?? 0;

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
        .query(AssetHistoryTimeValue_.assetSymbol.equals(marketInfo.symbol) &
            AssetHistoryTimeValue_.date.greaterOrEqualDate(startDate))
        .order(AssetHistoryTimeValue_.date)
        .build()
        .find();
  }

  @override
  Future<double?> checkShareSplit(
    BuildContext context,
    String symbol,
    AssetTimeValue position,
  ) async {
    final splitHistory = await stockApi!.getSplitHistorical(symbol);
    if (splitHistory.isEmpty) return null;

    double qtX = position.quantity;
    for (var split in splitHistory) {
      if (position.date.isBefore(split.dateFormatted)) {
        qtX = (qtX.toDecimal() *
            split.numerator.toDecimal() /
            split.denominator.toDecimal()).toDouble();
      }
    }
    if (qtX == 1) {
      return null;
    }

    bool? yes = await showYesNoBottomSheet(
      context,
      t.stock_split_message_position.replaceAll(
          "<qt>", position.quantity.toStringFormatted()).replaceAll(
          "<qtSplit>", qtX.toStringFormatted()),
      isDismissible: false,
    );

    if (yes == true) {
      return qtX;
    }
    return null;
  }

  @override
  Future<Map<AssetTimeValue, double>?> checkShareSplitMultiPositions(
    BuildContext context,
    String symbol,
    List<AssetTimeValue> positions,
  ) async {
    if (positions.isEmpty) return null;

    final splitHistory = await stockApi!.getSplitHistorical(symbol);
    if (splitHistory.isEmpty) return null;

    Map<AssetTimeValue, double> positionsInfluencedBySplit = {};

    for (var pos in positions) {
      double qtX = pos.quantity;
      for (var split in splitHistory) {
        if (pos.date.isBefore(split.dateFormatted)) {
          qtX = (qtX.toDecimal() *
              split.numerator.toDecimal() /
              split.denominator.toDecimal())
              .toDouble();
        }
      }
      if (qtX != 1) {
        positionsInfluencedBySplit.addAll({pos: qtX});
      }
    }

    if (positionsInfluencedBySplit.isNotEmpty) {
      var message = positionsInfluencedBySplit.entries
          .map((entry) => t.stock_split_message_single
          .replaceAll(
          "<date>", DateFormat("dd/MM/yyyy").format(entry.key.date))
          .replaceAll("<qt>", entry.key.quantity.toStringFormatted())
          .replaceAll("<qtSplit>", entry.value.toStringFormatted()))
          .join("\n");

      bool? yes = await showYesNoBottomSheet(context,
          t.stock_split_message_positions.replaceAll("<message>", message),
          isDismissible: false,
          widgetAboveSelection: IconButton(
              onPressed: () {
                showOkOnlyBottomSheet(context, t.what_is_a_share_split_content);
              },
              icon: Text(
                t.what_is_a_share_split,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white),
              )));

      if (yes == true) {
        return positionsInfluencedBySplit;
      }
    }
    return null;
  }
}
