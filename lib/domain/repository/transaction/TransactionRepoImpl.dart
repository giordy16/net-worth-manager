// import 'package:get/get.dart';
// import 'package:net_worth_manager/data/ProductEntity.dart';
// import 'package:net_worth_manager/data/TransactionEntity.dart';
// import 'package:net_worth_manager/domain/repository/products/ProductRepoImpl.dart';
//
// import '../../database/AppDatabase.dart';
// import '../../database/dao/TransactionDAO.dart';
// import '../products/ProductRepo.dart';
// import 'TransactionRepo.dart';
//
// class TransactionRepoImpl extends GetxController implements TransactionRepo {
//
//   late AppDatabase database;
//   late TransactionDAO transactionDAO;
//   final ProductRepo _productRepo = Get.put(ProductRepoImpl());
//
//   @override
//   Future<void> onInit() async {
//     database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
//     transactionDAO = database.transactionDAO;
//
//     super.onInit();
//   }
//
//   @override
//   Future<void> addTransaction(TransactionEntity transaction, ProductEntity product) async {
//     try {
//       await _productRepo.insertProduct(product);
//       await transactionDAO.insertTransaction(transaction);
//     } catch(e) {
//       print(e);
//     }
//   }
//
//   @override
//   Future<void> updateTransaction(TransactionEntity transaction) async {
//     try {
//       await transactionDAO.updateTransaction(transaction);
//     } catch(e) {
//       print(e);
//     }
//   }
//
//   @override
//   Future<List<TransactionEntity>?> getTransactions() async {
//     try {
//       return await transactionDAO.findAllTransactions();
//     } catch(e) {
//       print(e);
//       return null;
//     }
//   }
//
//   @override
//   Future<List<TransactionEntity>?> getTransactionsByProduct(String product) async {
//     try {
//       return await transactionDAO.findAllTransactionByProduct(product);
//     } catch(e) {
//       print(e);
//       return null;
//     }
//   }
//
// }