import 'package:get_it/get_it.dart';
import 'package:objectbox/objectbox.dart';

import '../../objectbox.g.dart';
import 'asset_obox.dart';

@Entity()
class AssetCategory {
  @Id()
  int id = 0;

  String name;

  bool userCanSelect;

  AssetCategory(this.name, {this.userCanSelect = true});

  @override
  String toString() {
    return name;
  }

  bool operator ==(dynamic other) =>
      other != null && other is AssetCategory && name == other.name;

  @override
  int get hashCode => id.hashCode;

  List<Asset> getAssets() {
    return GetIt.I<Store>()
        .box<Asset>()
        .query(Asset_.category.equals(id))
        .build()
        .find();
  }

  double getValue() {
    double value = 0;
    for (var asset in getAssets()) {
      value = value + asset.getCurrentValue();
    }
    return value;
  }

}
