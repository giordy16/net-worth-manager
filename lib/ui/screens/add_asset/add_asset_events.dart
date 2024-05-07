import 'package:net_worth_manager/models/obox/asset_category_obox.dart';

abstract class AddAssetEvent {}

class ChangeNameEvent extends AddAssetEvent {
  String value;

  ChangeNameEvent(this.value);
}

class ChangeCategoryEvent extends AddAssetEvent {
  AssetCategory value;

  ChangeCategoryEvent(this.value);
}

class SaveAssetEvent extends AddAssetEvent {}

class FetchAddAssetData extends AddAssetEvent {}
