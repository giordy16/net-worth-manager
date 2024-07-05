import 'package:objectbox/objectbox.dart';

@Entity()
class NetWorthHistory {
  @Id()
  int? id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  NetWorthHistory(this.date, this.value);

}