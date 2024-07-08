import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:net_worth_manager/models/obox/asset_time_value_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import 'package:net_worth_manager/ui/screens/sell_position/sell_position_state.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';

import '../../../domain/repository/asset/asset_repo.dart';
import '../../../models/obox/asset_obox.dart';

class SellPositionCubit extends Cubit<SellPositionState> {
  Asset asset;
  AssetTimeValue position;
  AssetRepo assetRepo;

  SellPositionCubit({
    required this.asset,
    required this.position,
    required this.assetRepo,
  }) : super(SellPositionState.initial(
          asset: asset,
          position: position,
          sellDate: DateTime.now(),
        )) {
    initPage();
  }

  void initPage() {
    var selectableAsset = assetRepo.getAssets();

    // show only simple asset
    selectableAsset =
        selectableAsset.where((e) => e.marketInfo.target == null).toList();

    // necessary otherwise the dropdown throw an exception
    var selectedMoveAsset = state.selectedAsset == null
        ? null
        : selectableAsset.where((a) => a.id == state.selectedAsset!.id).first;
    var selectedTaxAsset = state.selectedTaxAsset == null
        ? null
        : selectableAsset
            .where((a) => a.id == state.selectedTaxAsset!.id)
            .first;

    emit(state.copyWith(
      selectableAssets: selectableAsset,
      quantityToSell: state.quantityToSell ?? position.quantity,
      sellDate: state.sellDate ?? DateTime.now(),
      selectedAsset: selectedMoveAsset,
      selectedTaxAsset: selectedTaxAsset,
    ));
    calcPositionValue();
  }

  void onQuantityChange(double qt) {
    emit(state.copyWith(quantityToSell: qt));
    calcPositionValue();
  }

  void onMoveAssetChange(bool value) {
    emit(state.copyWith(shouldMoveToAsset: value));
  }

  void onAssetSelected(Asset value) {
    emit(state.copyWith(selectedAsset: value));
  }

  void onApplyTaxChange(bool value) {
    emit(state.copyWith(shouldApplyTax: value));
  }

  void onTaxChange(double value) {
    emit(state.copyWith(taxAmount: value));
    calcPositionValue();
  }

  void onAddTaxToAsset(bool value) {
    emit(state.copyWith(shouldAddTaxToAsset: value));
  }

  void onSellDateChange(DateTime value) {
    emit(state.copyWith(sellDate: value));
  }

  void onTaxAssetSelected(Asset value) {
    emit(state.copyWith(selectedTaxAsset: value));
  }

  void calcPositionValue() {
    double positionValue = state.quantityToSell! *
        asset.marketInfo.target!
            .getCurrentPrice()
            .atMainCurrency(fromCurrency: asset.marketInfo.target!.currency);
    double netValue = positionValue - (state.taxAmount * positionValue / 100);

    emit(state.copyWith(
        positionValue: double.parse(netValue.toStringAsFixed(2))));
  }

  void sell() {
    if (state.quantityToSell == position.quantity) {
      // sold all the position, delete it
      assetRepo.deletePosition(asset, position);
    } else {
      // partial sell
      position.quantity =
          (position.quantity.toDecimal() - state.quantityToSell!.toDecimal())
              .toDouble();
      assetRepo.updatePosition(position);
    }

    if (state.shouldMoveToAsset) {
      double valueAtDateTime =
          assetRepo.getValueAtDateTime(state.selectedAsset!, state.sellDate!);

      assetRepo.saveAssetPosition(
          AssetTimeValue(
            date: state.sellDate!,
            value:
                (valueAtDateTime.toDecimal() + state.positionValue.toDecimal())
                    .toDouble(),
          ),
          state.selectedAsset!);
    }

    if (state.shouldAddTaxToAsset) {
      double valueAtDateTime = assetRepo.getValueAtDateTime(
          state.selectedTaxAsset!, state.sellDate!);

      double positionValue = state.quantityToSell! *
          asset.marketInfo.target!
              .getCurrentPrice()
              .atMainCurrency(fromCurrency: asset.marketInfo.target!.currency);
      double taxValue = state.taxAmount * positionValue / 100;

      assetRepo.saveAssetPosition(
          AssetTimeValue(
            date: state.sellDate!,
            value:
                (valueAtDateTime.toDecimal() - taxValue.toDecimal()).toDouble(),
          ),
          state.selectedTaxAsset!);
    }
  }
}
