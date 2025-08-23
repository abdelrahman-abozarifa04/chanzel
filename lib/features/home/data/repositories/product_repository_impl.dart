import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/domain/repositories/product_repository.dart';
import 'package:chanzel/core/services/logger_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Mock data for now - in a real app, this would come from API or database
  final List<Product> _mockProducts = [
    Product(
      name: 'Classic White T-Shirt',
      price: '150 LE',
      image: 'https://example.com/white-tshirt.jpg',
      description: 'Premium cotton classic white t-shirt for everyday wear',
      rating: 4.5,
    ),
    Product(
      name: 'Denim Jeans',
      price: '450 LE',
      image: 'https://example.com/denim-jeans.jpg',
      description: 'Comfortable denim jeans with perfect fit',
      rating: 4.3,
    ),
    Product(
      name: 'Casual Sneakers',
      price: '320 LE',
      image: 'https://example.com/sneakers.jpg',
      description: 'Stylish and comfortable casual sneakers',
      rating: 4.7,
    ),
    Product(
      name: 'Formal Shirt',
      price: '280 LE',
      image: 'https://example.com/formal-shirt.jpg',
      description: 'Elegant formal shirt for professional occasions',
      rating: 4.4,
    ),
    Product(
      name: 'Summer Dress',
      price: '380 LE',
      image: 'https://example.com/summer-dress.jpg',
      description: 'Beautiful summer dress perfect for warm weather',
      rating: 4.6,
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    try {
      Logger.info('Fetching all products');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_mockProducts);
    } catch (e) {
      Logger.error('Error fetching products: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      Logger.info('Fetching products for category: $category');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock category filtering - in real app, this would be API call
      switch (category.toLowerCase()) {
        case 'men':
          return _mockProducts.where((p) => 
            p.name.toLowerCase().contains('shirt') || 
            p.name.toLowerCase().contains('jeans') ||
            p.name.toLowerCase().contains('sneakers')
          ).toList();
        case 'women':
          return _mockProducts.where((p) => 
            p.name.toLowerCase().contains('dress')
          ).toList();
        case 'kids':
          return _mockProducts.where((p) => 
            p.name.toLowerCase().contains('sneakers')
          ).toList();
        default:
          return _mockProducts;
      }
    } catch (e) {
      Logger.error('Error fetching products by category: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      Logger.info('Fetching product with ID: $id');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Mock ID lookup - in real app, this would be API call
      if (id.isNotEmpty && _mockProducts.isNotEmpty) {
        return _mockProducts.first;
      }
      return null;
    } catch (e) {
      Logger.error('Error fetching product by ID: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      Logger.info('Searching products with query: $query');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      if (query.trim().isEmpty) {
        return [];
      }
      
      final lowercaseQuery = query.toLowerCase();
      return _mockProducts.where((product) =>
        product.name.toLowerCase().contains(lowercaseQuery) ||
        product.description.toLowerCase().contains(lowercaseQuery)
      ).toList();
    } catch (e) {
      Logger.error('Error searching products: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      Logger.info('Fetching featured products');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Return products with high ratings as featured
      return _mockProducts.where((product) => product.rating >= 4.5).toList();
    } catch (e) {
      Logger.error('Error fetching featured products: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsWithPagination({
    required int page,
    required int limit,
  }) async {
    try {
      Logger.info('Fetching products with pagination: page $page, limit $limit');
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;
      
      if (startIndex >= _mockProducts.length) {
        return [];
      }
      
      return _mockProducts.sublist(
        startIndex,
        endIndex > _mockProducts.length ? _mockProducts.length : endIndex,
      );
    } catch (e) {
      Logger.error('Error fetching products with pagination: $e', error: e);
      rethrow;
    }
  }
}
