import 'package:floor/floor.dart';
import 'package:forex_conversion/forex_conversion.dart';

@entity
class ProductEntity {
  @PrimaryKey()
  final String ticker;
  final String name;
  final String type;
  final String currency;
  double lastPrice;
  double lastPriceOnMainCurrency;
  final String? isin;
  final double? annualTer;

  ProductEntity(this.name, this.ticker, this.type, this.currency,
      this.lastPrice, this.lastPriceOnMainCurrency,
      {this.isin, this.annualTer});

  Future<void> updateLastPrice(double price) async {
    final fx = Forex();

    lastPrice = price;
    lastPriceOnMainCurrency = await fx.getCurrencyConverted(
        sourceCurrency: currency,
        destinationCurrency: "EUR", // todo change with main currency
        sourceAmount: lastPrice);
  }
}
