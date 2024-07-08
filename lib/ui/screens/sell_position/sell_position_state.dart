import 'package:equatable/equatable.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';

import '../../../models/obox/asset_obox.dart';

class SellPositionState extends Equatable {
  Asset asset;
  AssetTimeValue position;

  DateTime? sellDate;

  double? quantityToSell;
  double positionValue;

  bool shouldMoveToAsset;
  Asset? selectedAsset;
  List<Asset> selectableAssets;

  bool shouldApplyTax;
  double taxAmount;
  bool shouldAddTaxToAsset;
  Asset? selectedTaxAsset;

  SellPositionState({
    required this.asset,
    required this.position,
    required this.sellDate,
    required this.quantityToSell,
    required this.positionValue,
    required this.shouldMoveToAsset,
    required this.selectableAssets,
    required this.shouldApplyTax,
    required this.taxAmount,
    required this.shouldAddTaxToAsset,
    this.selectedAsset,
    this.selectedTaxAsset,
  });

  SellPositionState.initial({
    required this.asset,
    required this.position,
    this.sellDate,
    this.quantityToSell,
    this.positionValue = 0,
    this.shouldMoveToAsset = false,
    this.selectableAssets = const [],
    this.shouldApplyTax = false,
    this.taxAmount = 0,
    this.shouldAddTaxToAsset = false,
    this.selectedTaxAsset,
    this.selectedAsset,
  });

  SellPositionState copyWith({
    double? quantityToSell,
    double? positionValue,
    bool? shouldMoveToAsset,
    Asset? selectedAsset,
    List<Asset>? selectableAssets,
    bool? shouldApplyTax,
    double? taxAmount,
    Asset? selectedTaxAsset,
    bool? shouldAddTaxToAsset,
    DateTime? sellDate,
  }) {
    return SellPositionState(
        asset: asset,
        position: position,
        sellDate: sellDate ?? this.sellDate,
        quantityToSell: quantityToSell ?? this.quantityToSell,
        positionValue: positionValue ?? this.positionValue,
        shouldMoveToAsset: shouldMoveToAsset ?? this.shouldMoveToAsset,
        selectedAsset: selectedAsset ?? this.selectedAsset,
        selectableAssets: selectableAssets ?? this.selectableAssets,
        shouldApplyTax: shouldApplyTax ?? this.shouldApplyTax,
        taxAmount: taxAmount ?? this.taxAmount,
        shouldAddTaxToAsset: shouldAddTaxToAsset ?? this.shouldAddTaxToAsset,
        selectedTaxAsset: selectedTaxAsset ?? this.selectedTaxAsset);
  }

  @override
  List<Object?> get props => [
        asset,
        position,
        sellDate,
        quantityToSell,
        positionValue,
        shouldMoveToAsset,
        selectedAsset,
        selectableAssets,
        shouldApplyTax,
        taxAmount,
        shouldAddTaxToAsset,
        selectedTaxAsset,
      ];
}
