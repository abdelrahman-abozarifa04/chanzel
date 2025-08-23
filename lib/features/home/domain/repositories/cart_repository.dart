import 'package:chanzel/features/home/domain/models/product.dart';

class CartItem {
  final Product product;
  final String size;
  final int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.quantity,
  });

  double get totalPrice {
    final price = double.tryParse(product.price.replaceAll(' LE', '')) ?? 0.0;
    return price * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      size: json['size'],
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({
    Product? product,
    String? size,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}

abstract class CartRepository {
  /// Get all cart items
  Future<List<CartItem>> getCartItems();
  
  /// Add item to cart
  Future<void> addToCart(Product product, {String size, int quantity});
  
  /// Remove item from cart
  Future<void> removeFromCart(int index);
  
  /// Update item quantity
  Future<void> updateQuantity(int index, int quantity);
  
  /// Clear cart
  Future<void> clearCart();
  
  /// Get cart total price
  Future<double> getCartTotal();
  
  /// Get cart items count
  Future<int> getCartItemsCount();
}
