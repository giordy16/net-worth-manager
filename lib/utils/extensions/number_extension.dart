import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:net_worth_manager/main.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';

import '../../objectbox.g.dart';
import '../forex.dart';

extension DoubleHelper on double {
  String toStringFormatted({
    bool removeGroupSeparator = false,
  }) {
    var decimalDigits = toString().length - toString().indexOf(".") - 1;

    String string = NumberFormat.decimalPatternDigits(
            locale: Platform.localeName, decimalDigits: decimalDigits)
        .format(this);

    if (removeGroupSeparator) {
      String groupSeparator =
          numberFormatSymbols[Platform.localeName.split("_").first]?.GROUP_SEP;
      string = string.replaceAll(groupSeparator, "");
    }

    return string;
  }

  String toStringWithCurrency({String? currency}) {
    Currency _currency;

    if (currency != null) {
      _currency = GetIt.I<Store>()
          .box<Currency>()
          .query(Currency_.name.equals(currency))
          .build()
          .findFirst()!;
    } else {
      _currency = GetIt.I<Settings>().defaultCurrency.target!;
    }

    return "${toStringFormatted()} ${_currency.symbol}";
  }

  double atMainCurrency({required String fromCurrency, DateTime? dateTime}) {
    double change = Forex.getCurrencyChange(fromCurrency, date: dateTime);
    return double.parse((change * this).toStringAsFixed(2));
  }
}
