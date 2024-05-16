import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/utils/extensions/number_extension.dart';
import 'package:objectbox/objectbox.dart';

import '../../main.dart';

@Entity()
class AssetTimeValue {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  double quantity;

  AssetTimeValue(
      {this.id = 0,
      required this.date,
      required this.value,
      this.quantity = 1});

  AssetTimeValue.empty()
      : id = 0,
        date = DateTime.now(),
        value = 0,
        quantity = 0;

  String getValueWithCurrency() {
    Settings settings = objectbox.store.box<Settings>().getAll().first;
    return "${settings.defaultCurrency.target?.symbol} ${value.toStringFormatted()}";
  }
}

extension AssetTimeValueHelper on AssetTimeValue {
  AssetTimeValue duplicate() {
    return AssetTimeValue(
      id: id,
      date: date,
      value: value,
      quantity: quantity,
    );
  }
}
