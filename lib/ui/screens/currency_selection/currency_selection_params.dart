import '../../../models/obox/currency_obox.dart';

class CurrencySelectionParams {
  Currency? selectedCurrency;
  Function(Currency)? onCurrencySelected;

  CurrencySelectionParams({
    this.selectedCurrency,
    this.onCurrencySelected,
  });
}
