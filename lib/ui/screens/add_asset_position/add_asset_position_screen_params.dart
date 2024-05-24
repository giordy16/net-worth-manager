import '../../../models/obox/asset_obox.dart';
import '../../../models/obox/asset_time_value_obox.dart';

class AddAssetPositionScreenParams {
  Asset asset;
  AssetTimeValue? timeValue;
  bool justPopBack;

  AddAssetPositionScreenParams({
    required this.asset,
    this.timeValue,
    this.justPopBack = false,
  });
}
