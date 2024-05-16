import 'dart:io';

import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

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
}
