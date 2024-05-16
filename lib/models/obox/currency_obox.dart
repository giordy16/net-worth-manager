import 'package:objectbox/objectbox.dart';

@Entity()
class Currency {

  @Id()
  int id = 0;

  String symbol; // €
  String name;   // EUR

  Currency(this.symbol, this.name);

  @override
  String toString() {
    return "$name - $symbol";
  }
}