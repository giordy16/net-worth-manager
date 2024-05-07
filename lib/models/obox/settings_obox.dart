import 'package:objectbox/objectbox.dart';
import 'currency_obox.dart';

@Entity()
class Settings {

  @Id()
  int id = 0;

  ToOne<Currency> defaultCurrency = ToOne<Currency>();
}
