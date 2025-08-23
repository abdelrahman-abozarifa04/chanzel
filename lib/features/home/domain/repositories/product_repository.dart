import 'package:chanzel/features/home/domain/models/product.dart';

abstract class ProductRepository {
  /// Get all products
  Future<List<Product>> getProducts();

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category);

  /// Get product by ID
  Future<Product?> getProductById(String id);

  /// Search products
  Future<List<Product>> searchProducts(String query);

  /// Get featured products
  Future<List<Product>> getFeaturedProducts();

  /// Get products with pagination
  Future<List<Product>> getProductsWithPagination({
    required int page,
    required int limit,
  });
}
