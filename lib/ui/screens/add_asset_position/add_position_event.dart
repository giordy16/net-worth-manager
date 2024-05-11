import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/ui/screens/add_asset_position/add_asset_position_screen_params.dart';

import '../../../models/obox/asset_obox.dart';

abstract class AddPositionEvent {}

class ChangeDateEvent extends AddPositionEvent {
  DateTime dateTime;

  ChangeDateEvent(this.dateTime);
}

class ChangeCostEvent extends AddPositionEvent {
  double? cost;

  ChangeCostEvent(this.cost);
}

class SavePositionEvent extends AddPositionEvent {
  AddAssetPositionScreenParams params;

  SavePositionEvent(this.params);
}

class DeletePositionEvent extends AddPositionEvent {
  Asset asset;
  AssetTimeValue position;

  DeletePositionEvent(this.asset, this.position);
}

class InitState extends AddPositionEvent {
  AssetTimeValue? value;

  InitState(this.value);
}
