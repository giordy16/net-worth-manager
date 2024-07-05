import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/models/obox/main_currency_forex_change.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';
import 'package:net_worth_manager/utils/extensions/date_time_extension.dart';

class Forex {
  static double getCurrencyChange(String fromCurrency,
      {DateTime? date, int interaction = 0}) {

    if (interaction == 20) {
      // if for 20 days in a row there are no forex value, return 0
      return 0;
    }

    String toCurrency = GetIt.instance<Settings>().defaultCurrency.target!.name;

    if (toCurrency == fromCurrency) return 1;

    date ??= DateTime.now().keepOnlyYMD();

    double? change = GetIt.instance<Store>()
        .box<CurrencyForexChange>()
        .query(CurrencyForexChange_.date.equalsDate(date) &
            CurrencyForexChange_.name.equals("$fromCurrency$toCurrency"))
        .build()
        .findFirst()
        ?.change;

    if (change != null) {
      return change;
    } else {
      return getCurrencyChange(
        fromCurrency,
        date: date.subtract(const Duration(days: 1)),
        interaction: interaction + 1
      );
    }
  }
}
