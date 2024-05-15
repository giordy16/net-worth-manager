abstract class CurrencySelectionEvent {}

class FetchCurrencies extends CurrencySelectionEvent {
  String searchText;

  FetchCurrencies({this.searchText = ""});
}
