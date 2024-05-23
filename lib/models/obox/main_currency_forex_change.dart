import 'package:objectbox/objectbox.dart';

@Entity()
class CurrencyForexChange {
  @Id()
  int id = 0;

  String name; // "USDEUR", "GBPEUR", ....

  @Property(type: PropertyType.date)
  DateTime date;

  double change;

  CurrencyForexChange(this.name, this.date, this.change);
}
