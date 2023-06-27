import 'package:net_worth_manager/data/TransactionEntity.dart';

import '../../../data/ProductEntity.dart';

abstract class TransactionRepo {
  Future<void> addTransaction(TransactionEntity transaction, ProductEntity product);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>?> getTransactions();
  Future<List<TransactionEntity>?> getTransactionsByProduct(String product);
}