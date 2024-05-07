import 'package:objectbox/objectbox.dart';

@Entity()
class AssetCategory {
  @Id()
  int id = 0;

  String name;

  AssetCategory(this.name);

  @override
  String toString() {
    return name;
  }

  bool operator ==(dynamic other) =>
      other != null && other is AssetCategory && name == other.name;

  @override
  int get hashCode => id.hashCode;
}
