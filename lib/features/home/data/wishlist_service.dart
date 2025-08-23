import 'dart:convert';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chanzel/core/services/logger_service.dart';

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal() {
    _loadWishlistFromStorage();
  }

  final List<Product> _wishlistedProducts = [];
  static const String _wishlistKey = 'wishlist_items';

  // Get all wishlisted products
  List<Product> get wishlistedProducts =>
      List.unmodifiable(_wishlistedProducts);

  // Get count of wishlisted products
  int get wishlistCount => _wishlistedProducts.length;

  // Check if a product is wishlisted
  bool isProductWishlisted(Product product) {
    return _wishlistedProducts.any((p) => p.name == product.name);
  }

  // Add product to wishlist
  void addToWishlist(Product product) {
    if (!isProductWishlisted(product)) {
      _wishlistedProducts.add(product.copyWith(isWishlisted: true));
      _saveWishlistToStorage();
      _notifyListeners();
    }
  }

  // Remove product from wishlist
  void removeFromWishlist(Product product) {
    _wishlistedProducts.removeWhere((p) => p.name == product.name);
    _saveWishlistToStorage();
    _notifyListeners();
  }

  // Toggle wishlist status
  void toggleWishlist(Product product) {
    if (isProductWishlisted(product)) {
      removeFromWishlist(product);
    } else {
      addToWishlist(product);
    }
  }

  // Clear all wishlisted products
  void clearWishlist() {
    _wishlistedProducts.clear();
    _saveWishlistToStorage();
    _notifyListeners();
  }

  // Listeners for UI updates
  final List<Function()> _listeners = [];

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // Dispose all listeners
  void dispose() {
    _listeners.clear();
  }

  /// Save wishlist to local storage
  Future<void> _saveWishlistToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = _wishlistedProducts
          .map((item) => item.toJson())
          .toList();
      await prefs.setString(_wishlistKey, jsonEncode(wishlistJson));
    } catch (e) {
      Logger.error('Error saving wishlist to storage: $e', error: e);
    }
  }

  /// Load wishlist from local storage
  Future<void> _loadWishlistFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistString = prefs.getString(_wishlistKey);
      if (wishlistString != null) {
        final wishlistJson = jsonDecode(wishlistString) as List;
        _wishlistedProducts.clear();
        _wishlistedProducts.addAll(
          wishlistJson.map((json) => Product.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      Logger.error('Error loading wishlist from storage: $e', error: e);
    }
  }
}
