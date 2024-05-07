import 'package:equatable/equatable.dart';
import '../../../models/obox/asset_category_obox.dart';

class AddAssetState extends Equatable {
  final String assetName;
  final List<AssetCategory> assetCategorySelectable;
  final AssetCategory? assetCategory;

  const AddAssetState.empty()
      : assetName = "",
        assetCategorySelectable = const [],
        assetCategory = null;

  const AddAssetState({
    required this.assetName,
    required this.assetCategorySelectable,
    required this.assetCategory,
  });

  AddAssetState copyWith({
    String? assetName,
    List<AssetCategory>? assetCategorySelectable,
    AssetCategory? assetCategory,
  }) {
    return AddAssetState(
      assetName: assetName ?? this.assetName,
      assetCategorySelectable:
          assetCategorySelectable ?? this.assetCategorySelectable,
      assetCategory: assetCategory ?? this.assetCategory,
    );
  }

  @override
  List<Object?> get props =>
      [assetName, assetCategorySelectable, assetCategory];
}
