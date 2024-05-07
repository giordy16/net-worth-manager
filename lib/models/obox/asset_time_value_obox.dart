import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';

@Entity()
class AssetTimeValue {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  AssetTimeValue(this.date, this.value);

  String getLastValueWithCurrency() {
    Settings settings = objectbox.store.box<Settings>().getAll().first;
    return "${settings.defaultCurrency.target?.symbol} $value";
  }
}
