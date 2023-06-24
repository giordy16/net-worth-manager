import 'package:intl/intl.dart';

extension NumberExtension on double {

  String formatted() {
    var nf = NumberFormat.simpleCurrency(name: "EUR");
    return nf.format(this);
  }

  String formattedPerc() {
    var nf = NumberFormat("0.0#");
    return nf.format(this);
  }

}