/*
 * Copyright (c) 2025 Abdelrahman Sami. All rights reserved.
 * 
 * This application is the property of Abdelrahman Sami.
 * Unauthorized copying, distribution, or modification of this application
 * is strictly prohibited.
 */

import 'dart:convert';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/data/promo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chanzel/core/services/logger_service.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal() {
    _loadCartFromStorage();
  }

  final List<CartItem> _cartItems = [];
  static const String _cartKey = 'cart_items';

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  void addToCart(Product product, {String size = 'M'}) {
    // Check if product already exists in cart
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.name == product.name && item.size == size,
    );

    if (existingIndex != -1) {
      // Increment quantity if product already exists
      _cartItems[existingIndex].quantity++;
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(product: product, size: size, quantity: 1));
    }
    _saveCartToStorage();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      _saveCartToStorage();
    }
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < _cartItems.length) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      _saveCartToStorage();
    }
  }

  void clearCart() {
    _cartItems.clear();
    // Clear promo code when cart is cleared
    PromoService().clearPromoData();
    _saveCartToStorage();
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (total, item) {
      final price =
          double.tryParse(item.product.price.replaceAll(' LE', '')) ?? 0.0;
      return total + (price * item.quantity);
    });
  }

  int get totalItems {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
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

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({required this.product, required this.size, this.quantity = 1});

  double get totalPrice {
    final price = double.tryParse(product.price.replaceAll(' LE', '')) ?? 0.0;
    return price * quantity;
  }

  /// Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'size': size, 'quantity': quantity};
  }

  /// Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}
