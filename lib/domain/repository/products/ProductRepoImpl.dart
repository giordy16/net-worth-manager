import 'package:get/get.dart';
import 'package:net_worth_manager/data/ProductEntity.dart';
import 'package:net_worth_manager/domain/database/dao/ProductDAO.dart';

import '../../database/AppDatabase.dart';
import 'ProductRepo.dart';

class ProductRepoImpl extends GetxController implements ProductRepo {
  late AppDatabase database;
  late ProductDAO productDAO;

  @override
  Future<void> onInit() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    productDAO = database.productDAO;

    super.onInit();
  }

  @override
  Future<ProductEntity?> getProductById(String ticker) async {
    try {
      return await productDAO.findProductById(ticker);
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<ProductEntity>?> getProducts() async {
    try {
      return await productDAO.findAllProducts();
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> insertProduct(ProductEntity product) async {
    try {
      await productDAO.insertProduct(product);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    try {
      await productDAO.updateProduct(product);
    } catch (e) {
      print(e);
    }
  }
}
