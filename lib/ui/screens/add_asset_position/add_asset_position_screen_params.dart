import '../../../models/obox/asset_obox.dart';
import '../../../models/obox/asset_time_value_obox.dart';

class AddAssetPositionScreenParams {
  Asset asset;
  AssetTimeValue? timeValue;
  bool justPopBack;

  // the sell button will be visible only for asset investments
  bool showSellButton;

  AddAssetPositionScreenParams({
    required this.asset,
    this.timeValue,
    this.justPopBack = false,
    this.showSellButton = false,
  });
}
