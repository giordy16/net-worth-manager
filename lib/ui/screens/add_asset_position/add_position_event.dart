import '../../../models/obox/asset_obox.dart';

abstract class AddPositionEvent {}

class ChangeDateEvent extends AddPositionEvent {
  DateTime dateTime;

  ChangeDateEvent(this.dateTime);
}

class ChangeCostEvent extends AddPositionEvent {
  double cost;

  ChangeCostEvent(this.cost);
}

class SavePositionEvent extends AddPositionEvent {
  Asset asset;

  SavePositionEvent(this.asset);
}
