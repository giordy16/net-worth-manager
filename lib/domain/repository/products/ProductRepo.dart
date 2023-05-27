import 'package:net_worth_manager/data/ProductEntity.dart';


abstract class ProductRepo {
  Future<List<ProductEntity>?> getProducts();
  Future<ProductEntity?> getProductById(String ticker);
  Future<void> insertProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
}