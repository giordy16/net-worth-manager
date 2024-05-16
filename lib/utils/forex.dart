import 'package:net_worth_manager/main.dart';

import '../models/obox/currency_obox.dart';
import '../models/obox/market_info_obox.dart';
import '../models/obox/settings_obox.dart';
import 'package:forex_conversion/forex_conversion.dart';

Future<void> fetchForexExchange() async {
  Currency defaultCurrency =
      objectbox.store.box<Settings>().getAll().first.defaultCurrency.target!;

  List<String> assetCurrencies = objectbox.store
      .box<MarketInfo>()
      .getAll()
      .map((e) => e.currency)
      .toSet()
      .toList();

  currencyChange.clear();

  final fx = Forex();
  for (var currency in assetCurrencies) {
    double change = await fx.getCurrencyConverted(
      sourceCurrency: currency,
      destinationCurrency: defaultCurrency.name,
      sourceAmount: 1,
    );
    currencyChange.addAll({"$currency${defaultCurrency.name}": change});
  }
  print(currencyChange);
}
