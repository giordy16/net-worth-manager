import 'package:objectbox/objectbox.dart';

import '../../utils/forex.dart';

@Entity()
class AssetHistoryTimeValue {
  @Id()
  int? id = 0;

  @Property(type: PropertyType.date)
  DateTime date;

  double value;

  AssetHistoryTimeValue(this.date, this.value);

  double getValueAtMainCurrency(String currency, DateTime date) {
    double change = Forex.getCurrencyChange(currency, date: date);
    return double.parse((change * value).toStringAsFixed(2));
  }
}