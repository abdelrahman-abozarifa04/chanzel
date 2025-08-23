import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  /// Execute the use case to get all products
  Future<List<Product>> execute() async {
    return await _repository.getProducts();
  }
}

class GetProductsByCategoryUseCase {
  final ProductRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  /// Execute the use case to get products by category
  Future<List<Product>> execute(String category) async {
    return await _repository.getProductsByCategory(category);
  }
}

class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  /// Execute the use case to search products
  Future<List<Product>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchProducts(query);
  }
}

class GetProductsWithPaginationUseCase {
  final ProductRepository _repository;

  GetProductsWithPaginationUseCase(this._repository);

  /// Execute the use case to get products with pagination
  Future<List<Product>> execute({
    required int page,
    required int limit,
  }) async {
    if (page < 1 || limit < 1) {
      throw ArgumentError('Page and limit must be greater than 0');
    }
    return await _repository.getProductsWithPagination(
      page: page,
      limit: limit,
    );
  }
}
