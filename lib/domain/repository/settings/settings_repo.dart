import 'package:net_worth_manager/models/obox/currency_obox.dart';

abstract class SettingsRepo {
  void setCurrency(Currency currency);
  Currency? getDefaultCurrency();
}