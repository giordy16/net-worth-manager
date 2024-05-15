import 'package:objectbox/objectbox.dart';

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
}
