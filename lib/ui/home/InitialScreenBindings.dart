import 'package:get/get.dart';
import 'package:net_worth_manager/ui/investments/controller/InvestementsController.dart';

import '../../domain/repository/products/ProductRepoImpl.dart';
import '../../domain/repository/transaction/TransactionRepoImpl.dart';

class InitialScreenBindings implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => InvestmentsController());
    Get.lazyPut(() => TransactionRepoImpl());
    Get.lazyPut(() => ProductRepoImpl());
  }
}