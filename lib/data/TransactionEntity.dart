import 'package:floor/floor.dart';

import 'ProductEntity.dart';

@Entity(foreignKeys: [
  ForeignKey(childColumns: ['product'], parentColumns: ['ticker'], entity: ProductEntity)
])
class TransactionEntity {
  @PrimaryKey(autoGenerate: true) int? id;

  final String product;
  final String date;
  final double price;
  final double qt;
  final String currencyTransaction;

  TransactionEntity(this.date, this.price, this.qt, this.currencyTransaction, this.product);
}
