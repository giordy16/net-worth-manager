import 'package:objectbox/objectbox.dart';

@Entity()
class AssetHistoryTimeValue {
  @Id()
  int? id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  AssetHistoryTimeValue(this.date, this.value);
}