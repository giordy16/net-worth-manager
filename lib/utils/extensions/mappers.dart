import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/market_info_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';

import '../../main.dart';
import '../../models/obox/asset_category_obox.dart';
import '../../models/obox/asset_obox.dart';

extension MarketInfoMapper on MarketInfo {
  Asset convertToAsset() {
    Asset? asset;

    // check if there is already this asset
    QueryBuilder<Asset> builder =
        GetIt.I<Store>().box<Asset>().query(Asset_.marketInfo.notNull());
    builder.link(Asset_.marketInfo, MarketInfo_.symbol.equals(symbol));
    asset = builder.build().findFirst();
    if (asset != null) {
      return asset;
    }

    asset = Asset(name);
    asset.marketInfo.target = this;
    asset.category.target =
        GetIt.I<Store>().box<AssetCategory>().getAll().first;

    return asset;
  }
}
