import 'package:floor/floor.dart';
import 'package:net_worth_manager/data/TransactionEntity.dart';

@dao
abstract class TransactionDAO {
  @Query('SELECT * FROM TransactionEntity')
  Future<List<TransactionEntity>> findAllTransactions();

  @Query('SELECT * FROM TransactionEntity WHERE product = :product')
  Future<List<TransactionEntity>?> findAllTransactionByProduct(String product);

  @insert
  Future<void> insertTransaction(TransactionEntity transaction);

  @update
  Future<void> updateTransaction(TransactionEntity transaction);
}