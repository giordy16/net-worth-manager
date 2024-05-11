import 'package:net_worth_manager/models/obox/asset_category_obox.dart';

import '../../../models/obox/asset_obox.dart';

abstract class AddAssetEvent {}

class ChangeNameEvent extends AddAssetEvent {
  String value;

  ChangeNameEvent(this.value);
}

class ChangeCategoryEvent extends AddAssetEvent {
  AssetCategory value;

  ChangeCategoryEvent(this.value);
}

class SetInitialValue extends AddAssetEvent {
  Asset? asset;

  SetInitialValue(this.asset);
}

class SaveAssetEvent extends AddAssetEvent {
  Asset? asset;

  SaveAssetEvent({this.asset});
}

class SaveAssetAndOpenPositionEvent extends AddAssetEvent {}

class FetchAddAssetData extends AddAssetEvent {}
