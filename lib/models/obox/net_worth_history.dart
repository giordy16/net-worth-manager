import 'package:objectbox/objectbox.dart';

import '../../utils/forex.dart';

@Entity()
class NetWorthHistory {
  @Id()
  int? id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  NetWorthHistory(this.date, this.value);

}