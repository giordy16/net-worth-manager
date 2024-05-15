import 'package:objectbox/objectbox.dart';

@Entity()
class MarketInfo {
  @Id()
  int? id = 0;

  String symbol;
  String name;
  String type;
  String currency;
  String region;
  double value;

  MarketInfo(
    this.symbol,
    this.name,
    this.type,
    this.currency,
    this.region, {
    this.value = 0,
  });
}
