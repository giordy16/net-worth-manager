import '../../../models/obox/asset_obox.dart';

abstract class AddMarketAssetEvent {}

class SaveMarketAssetEvent extends AddMarketAssetEvent {
  Asset asset;

  SaveMarketAssetEvent(this.asset);
}

// class PriceRecoveredEvent extends AddMarketAssetEvent {
//   Asset asset;
//
//   PriceRecoveredEvent(this.asset);
// }