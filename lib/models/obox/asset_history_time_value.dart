import 'package:objectbox/objectbox.dart';

import '../../utils/forex.dart';

@Entity()
class AssetHistoryTimeValue {
  @Id()
  int? id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  String assetName;

  double value;

  AssetHistoryTimeValue(this.date, this.value, this.assetName);

}