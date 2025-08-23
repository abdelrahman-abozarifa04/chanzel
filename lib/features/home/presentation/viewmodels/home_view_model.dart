import 'package:flutter/material.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/domain/repositories/cart_repository.dart';
import 'package:chanzel/features/home/domain/usecases/get_products_usecase.dart';
import 'package:chanzel/features/home/domain/usecases/cart_usecases.dart';
import 'package:chanzel/core/services/logger_service.dart';

class HomeViewModel extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetCartItemsCountUseCase _getCartItemsCountUseCase;
  final AddToCartUseCase _addToCartUseCase;

  HomeViewModel({
    required GetProductsUseCase getProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetCartItemsCountUseCase getCartItemsCountUseCase,
    required AddToCartUseCase addToCartUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       _getCartItemsCountUseCase = getCartItemsCountUseCase,
       _addToCartUseCase = addToCartUseCase {
    _initialize();
  }

  // State variables
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product> _searchResults = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  int _cartItemsCount = 0;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get searchResults => _searchResults;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  int get cartItemsCount => _cartItemsCount;
  String? get errorMessage => _errorMessage;

  // Initialize the view model
  Future<void> _initialize() async {
    await _loadProducts();
    await _loadCartItemsCount();
  }

  // Load all products
  Future<void> _loadProducts() async {
    try {
      _setLoading(true);
      _clearError();
      
      _products = await _getProductsUseCase.execute();
      _filteredProducts = List.from(_products);
      
      Logger.info('Loaded ${_products.length} products');
    } catch (e) {
      _setError('Failed to load products: $e');
      Logger.error('Error loading products: $e', error: e);
    } finally {
      _setLoading(false);
    }
  }

  // Load cart items count
  Future<void> _loadCartItemsCount() async {
    try {
      _cartItemsCount = await _getCartItemsCountUseCase.execute();
      notifyListeners();
    } catch (e) {
      Logger.error('Error loading cart items count: $e', error: e);
    }
  }

  // Filter products by category
  Future<void> filterByCategory(String category) async {
    try {
      _setLoading(true);
      _clearError();
      
      _selectedCategory = category;
      
      if (category == 'all') {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = await _getProductsByCategoryUseCase.execute(category);
      }
      
      Logger.info('Filtered products by category: $category');
    } catch (e) {
      _setError('Failed to filter products: $e');
      Logger.error('Error filtering products by category: $e', error: e);
    } finally {
      _setLoading(false);
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    try {
      _searchQuery = query;
      
      if (query.trim().isEmpty) {
        _searchResults.clear();
        _isSearching = false;
        notifyListeners();
        return;
      }

      _isSearching = true;
      notifyListeners();

      _searchResults = await _searchProductsUseCase.execute(query);
      
      Logger.info('Search completed for query: $query');
    } catch (e) {
      _setError('Search failed: $e');
      Logger.error('Error searching products: $e', error: e);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    _isSearching = false;
    notifyListeners();
  }

  // Add product to cart
  Future<void> addToCart(Product product, {String size = 'M', int quantity = 1}) async {
    try {
      await _addToCartUseCase.execute(product, size: size, quantity: quantity);
      await _loadCartItemsCount(); // Refresh cart count
      Logger.info('Product added to cart: ${product.name}');
    } catch (e) {
      _setError('Failed to add product to cart: $e');
      Logger.error('Error adding product to cart: $e', error: e);
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadProducts();
    await _loadCartItemsCount();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
