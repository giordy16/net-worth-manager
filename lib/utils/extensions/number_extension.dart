import 'dart:io';

import 'package:intl/intl.dart';

extension DoubleHelper on double {
  String toStringFormatted() {
    var decimalDigits = toString().length - toString().indexOf(".") - 1;

    return NumberFormat.decimalPatternDigits(
            locale: Platform.localeName, decimalDigits: decimalDigits)
        .format(this);
  }
}
