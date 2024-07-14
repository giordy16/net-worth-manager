import 'dart:io';
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:net_worth_manager/models/obox/currency_obox.dart';
import 'package:net_worth_manager/models/obox/settings_obox.dart';

import '../../objectbox.g.dart';
import '../forex.dart';

extension DoubleHelper on double {
  String toStringFormatted(
      {bool removeGroupSeparator = false,
      bool removeDecimalPartIfZero = false}) {
    var decimalDigits = toString().length - toString().indexOf(".") - 1;

    final formatter = NumberFormat.decimalPatternDigits(
      locale: Platform.localeName,
      decimalDigits: (removeDecimalPartIfZero && this - truncate() == 0)
          ? 0
          : decimalDigits,
    );

    if (removeGroupSeparator) {
      formatter.turnOffGrouping();
    }

    String string = formatter.format(this);

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

  Decimal toDecimal() {
    return Decimal.parse(toString());
  }

  double roundToClosestMultiple(double multiple) {
    return ((this + (multiple / 2)) ~/ multiple) * multiple;
  }

  double roundRoundUoToNextMultiple(double multiple) {
    return ((this + (multiple - 1)) ~/ multiple) * multiple;
  }

  double roundRoundUoToPreviousMultiple(double multiple) {
    return (this ~/ multiple) * multiple;
  }

  double roundMinGraph() {
    int numberOfDigits = abs().toInt().toString().length;
    int multiple = pow(10, numberOfDigits - 1).toInt();
    return roundRoundUoToPreviousMultiple(multiple.toDouble());
  }

  double roundMaxGraph() {
    int numberOfDigits = abs().toInt().toString().length;
    int multiple = pow(10, numberOfDigits - 1).toInt();
    return roundRoundUoToNextMultiple(multiple.toDouble());
  }
}
