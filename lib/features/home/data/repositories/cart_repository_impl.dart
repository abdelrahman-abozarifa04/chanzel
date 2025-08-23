import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/domain/repositories/cart_repository.dart';
import 'package:chanzel/core/services/logger_service.dart';

class CartRepositoryImpl implements CartRepository {
  static const String _cartKey = 'cart_items';
  final List<CartItem> _cartItems = [];

  CartRepositoryImpl() {
    _loadCartFromStorage();
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return List.unmodifiable(_cartItems);
  }

  @override
  Future<void> addToCart(
    Product product, {
    String size = 'M',
    int quantity = 1,
  }) async {
    try {
      // Check if product already exists in cart
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.name == product.name && item.size == size,
      );

      if (existingIndex != -1) {
        // Increment quantity if product already exists
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + quantity,
        );
      } else {
        // Add new item to cart
        _cartItems.add(
          CartItem(product: product, size: size, quantity: quantity),
        );
      }

      await _saveCartToStorage();
      Logger.info('Added ${product.name} to cart');
    } catch (e) {
      Logger.error('Error adding item to cart: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(int index) async {
    try {
      if (index >= 0 && index < _cartItems.length) {
        final removedItem = _cartItems.removeAt(index);
        await _saveCartToStorage();
        Logger.info('Removed ${removedItem.product.name} from cart');
      }
    } catch (e) {
      Logger.error('Error removing item from cart: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateQuantity(int index, int quantity) async {
    try {
      if (index >= 0 && index < _cartItems.length) {
        if (quantity <= 0) {
          await removeFromCart(index);
        } else {
          _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
          await _saveCartToStorage();
          Logger.info('Updated quantity for ${_cartItems[index].product.name}');
        }
      }
    } catch (e) {
      Logger.error('Error updating cart item quantity: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      _cartItems.clear();
      await _saveCartToStorage();
      Logger.info('Cart cleared');
    } catch (e) {
      Logger.error('Error clearing cart: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<double> getCartTotal() async {
    try {
      double total = 0.0;
      for (final item in _cartItems) {
        total += item.totalPrice;
      }
      return total;
    } catch (e) {
      Logger.error('Error calculating cart total: $e', error: e);
      return 0.0;
    }
  }

  @override
  Future<int> getCartItemsCount() async {
    try {
      int total = 0;
      for (final item in _cartItems) {
        total += item.quantity;
      }
      return total;
    } catch (e) {
      Logger.error('Error calculating cart items count: $e', error: e);
      return 0;
    }
  }

  /// Save cart to local storage
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _cartItems.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(cartJson));
    } catch (e) {
      Logger.error('Error saving cart to storage: $e', error: e);
    }
  }

  /// Load cart from local storage
  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);
      if (cartString != null) {
        final cartJson = jsonDecode(cartString) as List;
        _cartItems.clear();
        _cartItems.addAll(
          cartJson.map((json) => CartItem.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      Logger.error('Error loading cart from storage: $e', error: e);
    }
  }
}
