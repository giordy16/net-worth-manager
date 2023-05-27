import 'package:floor/floor.dart';

@entity
class ProductEntity {
  @PrimaryKey() final String ticker;
  final String name;
  final String type;
  final String currency;
  double lastPrice;
  final String? isin;
  final double? annualTer;

  ProductEntity(this.name, this.ticker, this.type, this.currency, this.lastPrice, {this.isin, this.annualTer});
}
