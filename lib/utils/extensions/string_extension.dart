import 'dart:io';

import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

extension StringHelper on String {
  double convertToDouble() {
    if (isEmpty) return 0;
    var decimalSeparator =
        numberFormatSymbols[Platform.localeName.split("_").last.toLowerCase()]?.DECIMAL_SEP;

    var decimalDigits = length - indexOf(decimalSeparator) - 1;
    return NumberFormat.decimalPatternDigits(
            locale: Platform.localeName, decimalDigits: decimalDigits)
        .parse(this) as double;
  }
}
