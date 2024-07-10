import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';

import '../../objectbox.g.dart';
import 'asset_obox.dart';

enum MarketAssetCategory { stocks, etfs, crypto, commodities }

@Entity()
class AssetCategory {
  @Id()
  int id = 0;

  String name;

  bool userCanSelect;

  int? marketAssetCategoryEnumId;

  MarketAssetCategory? get marketAssetCategory {
    return marketAssetCategoryEnumId == null
        ? null
        : MarketAssetCategory.values[marketAssetCategoryEnumId!];
  }

  void setMarketAssetCategory(MarketAssetCategory category) {
    marketAssetCategoryEnumId = MarketAssetCategory.values.indexOf(category);
  }

  AssetCategory(
    this.name, {
    this.userCanSelect = true,
    this.marketAssetCategoryEnumId,
  });

  @override
  String toString() {
    return name;
  }

  bool operator ==(dynamic other) =>
      other != null &&
      other is AssetCategory &&
      name == other.name &&
      marketAssetCategory == other.marketAssetCategory;

  @override
  int get hashCode => id.hashCode;

  List<Asset> getAssets() {
    return GetIt.I<Store>()
        .box<Asset>()
        .query(Asset_.category.equals(id))
        .build()
        .find();
  }

  double getValue() {
    double value = 0;
    for (var asset in getAssets()) {
      value = value + asset.getCurrentValue();
    }
    return double.parse(value.toStringAsFixed(2));
  }
}
