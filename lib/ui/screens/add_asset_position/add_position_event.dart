import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

import '../../../models/obox/asset_obox.dart';

abstract class AddPositionEvent {}

class SavePositionEvent extends AddPositionEvent {
  Asset asset;
  AssetTimeValue position;

  SavePositionEvent(this.asset, this.position);
}

class DeletePositionEvent extends AddPositionEvent {
  Asset asset;
  AssetTimeValue position;

  DeletePositionEvent(this.asset, this.position);
}
