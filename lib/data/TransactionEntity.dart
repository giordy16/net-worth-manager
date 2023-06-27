import 'package:floor/floor.dart';

import 'ProductEntity.dart';
import 'enum/TransactionTypeEnum.dart';

@Entity(foreignKeys: [
  ForeignKey(
      childColumns: ['product'],
      parentColumns: ['ticker'],
      entity: ProductEntity)
])
class TransactionEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String product;
  final String date;
  final double price;
  final double qt;
  final double currencyChange;
  final TransactionTypeEnum type;

  TransactionEntity(this.date, this.price, this.qt, this.currencyChange,
      this.product, this.type,
      {this.id});

  double getPriceOnAssetCurrency() {
    return price * currencyChange;
  }

  double getTotalCostOnAssetCurrency() {
    return price * currencyChange * qt;
  }
}
