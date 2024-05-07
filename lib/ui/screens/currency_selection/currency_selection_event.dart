import 'package:net_worth_manager/models/obox/currency_obox.dart';

abstract class CurrencySelectionEvent {}

class FetchCurrencies extends CurrencySelectionEvent {
  String searchText;

  FetchCurrencies({this.searchText = ""});
}

class CurrencySelected extends CurrencySelectionEvent {
  Currency selectedCurrency;

  CurrencySelected(this.selectedCurrency);
}
