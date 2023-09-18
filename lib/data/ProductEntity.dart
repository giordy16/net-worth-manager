import 'package:floor/floor.dart';
import 'package:forex_conversion/forex_conversion.dart';

@entity
class ProductEntity {
  @PrimaryKey()
  final String ticker;
  final String name;
  final String type;
  double lastPrice;
  double lastPriceOnUserCurrency;
  final String? currency;
  final String? isin;
  final double? annualTer;
  final String? exchange;
  final String? country;

  ProductEntity(this.name, this.ticker, this.type, this.lastPrice,
      this.lastPriceOnUserCurrency,
      {this.currency, this.isin, this.annualTer, this.exchange, this.country});

  Future<void> updateLastPrice(double price) async {
    final fx = Forex();

    lastPrice = price;
    lastPriceOnUserCurrency = await fx.getCurrencyConverted(
        sourceCurrency: currency,
        destinationCurrency: "EUR", // todo change with main currency
        sourceAmount: lastPrice);
  }
}
