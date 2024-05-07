import 'dart:io';

import 'package:intl/intl.dart';
import 'package:net_worth_manager/domain/database/objectbox.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';
import 'package:net_worth_manager/objectbox.g.dart';

import '../currency_enum.dart';

extension ObjectBoxExtension on ObjectBox {
  void initIfEmpty() {
    var currency = store.box<Currency>().getAll();
    if (currency.isEmpty) {
      // fill Currency table with all currencies
      for (var curr in CurrencyEnum.values) {
        var format = NumberFormat.simpleCurrency(
            locale: Platform.localeName, name: curr.name);
        store.box<Currency>().put(Currency(format.currencySymbol, curr.name));
      }
    }

    var settings = store.box<Settings>().getAll();
    if (settings.isEmpty) {
      // set defaultCurrency to the currency based on the phone's location

      var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
      Currency currency = store
              .box<Currency>()
              .query(Currency_.name.equals(format.currencyName!))
              .build()
              .findFirst() ??
          store.box<Currency>().getAll().first;

      Settings settings = Settings();
      settings.defaultCurrency.target = currency;
      store.box<Settings>().put(settings);
    }
  }
}
