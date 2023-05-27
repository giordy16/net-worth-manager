import 'package:floor/floor.dart';
import 'package:net_worth_manager/data/ProductEntity.dart';

@dao
abstract class ProductDAO {
  @Query('SELECT * FROM ProductEntity')
  Future<List<ProductEntity>> findAllProducts();

  @Query('SELECT * FROM ProductEntity WHERE ticker = :ticker')
  Future<ProductEntity?> findProductById(String ticker);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertProduct(ProductEntity products);

  @update
  Future<void> updateProduct(ProductEntity products);
}