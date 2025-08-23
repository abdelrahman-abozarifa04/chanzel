/*
 * Copyright (c) 2025 Abdelrahman Sami. All rights reserved.
 * 
 * This application is the property of Abdelrahman Sami.
 * Unauthorized copying, distribution, or modification of this application
 * is strictly prohibited.
 */

import 'dart:convert';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/features/home/data/promo_service.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chanzel/core/services/logger_service.dart';

// Order model to represent a completed order
class Order {
  final String orderId;
  final List<CartItem> items;
  final double totalAmount;
  final String orderDate;
  final String status;
  final String shippingAddress;

  Order({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });

  /// Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'status': status,
      'shippingAddress': shippingAddress,
    };
  }

  /// Create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      orderDate: json['orderDate'],
      status: json['status'],
      shippingAddress: json['shippingAddress'],
    );
  }
}

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal() {
    _loadOrdersFromStorage();
  }

  // Store completed orders
  final List<Order> _completedOrders = [];
  static const String _ordersKey = 'completed_orders';
  bool _isLoaded = false;

  // Get all completed orders
  List<Order> get completedOrders {
    if (!_isLoaded) {
      _loadOrdersFromStorage();
    }
    return List.unmodifiable(_completedOrders);
  }

  // Create a new order from cart items
  Order createOrderFromCart(List<CartItem> cartItems, String shippingAddress) {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final orderDate = DateTime.now().toString().split(
      ' ',
    )[0]; // YYYY-MM-DD format

    final order = Order(
      orderId: orderId,
      items: List.from(cartItems), // Create a copy of cart items
      totalAmount:
          CartService().totalPrice + 50, // Including shipping (updated fee)
      orderDate: orderDate,
      status: 'Processing',
      shippingAddress: shippingAddress,
    );

    // Add to completed orders
    _completedOrders.add(order);
    _saveOrdersToStorage();

    Logger.info('Created order ${order.orderId} with ${cartItems.length} items');
    Logger.info('Total orders in storage: ${_completedOrders.length}');

    return order;
  }

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _completedOrders.where((order) => order.status == status).toList();
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _completedOrders.indexWhere(
      (order) => order.orderId == orderId,
    );
    if (orderIndex != -1) {
      final order = _completedOrders[orderIndex];
      _completedOrders[orderIndex] = Order(
        orderId: order.orderId,
        items: order.items,
        totalAmount: order.totalAmount,
        orderDate: order.orderDate,
        status: newStatus,
        shippingAddress: order.shippingAddress,
      );
      _saveOrdersToStorage();
    }
  }

  // Clear all orders (for testing purposes)
  void clearOrders() {
    _completedOrders.clear();
    _saveOrdersToStorage();
  }

  // Force refresh orders from storage
  Future<void> refreshOrders() async {
    await _loadOrdersFromStorage();
  }

  // Debug method to check storage
  Future<void> debugStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersString = prefs.getString(_ordersKey);
      Logger.debug('Raw storage data: $ordersString');
      if (ordersString != null) {
        final ordersJson = jsonDecode(ordersString) as List;
        Logger.debug('Parsed JSON has ${ordersJson.length} orders');
      }
    } catch (e) {
      Logger.error('Debug storage error: $e', error: e);
    }
  }

  // Test method to create a sample order
  Future<void> createTestOrder() async {
    try {
      // Create a test product
      final testProduct = Product(
        name: 'Test Product',
        price: '100 LE',
        image: 'https://example.com/test.jpg',
        description: 'Test product description',
        rating: 4.5,
      );

      // Create a test cart item
      final testCartItem = CartItem(
        product: testProduct,
        size: 'M',
        quantity: 2,
      );

      // Create test order
      final testOrder = Order(
        orderId: 'TEST-${DateTime.now().millisecondsSinceEpoch}',
        items: [testCartItem],
        totalAmount: 200.0,
        orderDate: DateTime.now().toString().split(' ')[0],
        status: 'Processing',
        shippingAddress: 'Test Address',
      );

      // Add to orders
      _completedOrders.add(testOrder);
      await _saveOrdersToStorage();

      Logger.info('Test order created successfully');
      Logger.info('Total orders after test: ${_completedOrders.length}');
    } catch (e) {
      Logger.error('Error creating test order: $e', error: e);
    }
  }

  /// Save orders to local storage
  Future<void> _saveOrdersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = _completedOrders
          .map((order) => order.toJson())
          .toList();
      await prefs.setString(_ordersKey, jsonEncode(ordersJson));
      Logger.info('Saved ${_completedOrders.length} orders to storage');
    } catch (e) {
      Logger.error('Error saving orders to storage: $e', error: e);
    }
  }

  /// Load orders from local storage
  Future<void> _loadOrdersFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersString = prefs.getString(_ordersKey);
      if (ordersString != null) {
        final ordersJson = jsonDecode(ordersString) as List;
        _completedOrders.clear();
        _completedOrders.addAll(
          ordersJson.map((json) => Order.fromJson(json)).toList(),
        );
      }
      _isLoaded = true;
      Logger.info('Loaded ${_completedOrders.length} orders from storage');
    } catch (e) {
      Logger.error('Error loading orders from storage: $e', error: e);
      _isLoaded = true; // Mark as loaded even if there's an error
    }
  }
}
