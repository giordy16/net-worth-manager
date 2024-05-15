import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';

@Entity()
class AssetTimeValue {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  double quantity;

  AssetTimeValue(this.date, this.value, [this.quantity = 1]);

  AssetTimeValue.empty()
      : date = DateTime.now(),
        value = 0,
        quantity = 0;

  String getValueWithCurrency() {
    Settings settings = objectbox.store.box<Settings>().getAll().first;
    return "${settings.defaultCurrency.target?.symbol} ${value.toStringFormatted()}";
  }
}
