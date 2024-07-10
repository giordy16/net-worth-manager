import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

import '../../../models/obox/asset_obox.dart';

abstract class AddMarketAssetEvent {}

class SaveMarketAssetEvent extends AddMarketAssetEvent {
  Asset asset;
  List<AssetTimeValue> newPositions;

  SaveMarketAssetEvent(this.asset, this.newPositions);
}
