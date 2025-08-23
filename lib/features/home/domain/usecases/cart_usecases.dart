import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<void> execute(Product product, {String size = 'M', int quantity = 1}) async {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
    await _repository.addToCart(product, size: size, quantity: quantity);
  }
}

class RemoveFromCartUseCase {
  final CartRepository _repository;

  RemoveFromCartUseCase(this._repository);

  Future<void> execute(int index) async {
    if (index < 0) {
      throw ArgumentError('Index must be non-negative');
    }
    await _repository.removeFromCart(index);
  }
}

class UpdateCartItemQuantityUseCase {
  final CartRepository _repository;

  UpdateCartItemQuantityUseCase(this._repository);

  Future<void> execute(int index, int quantity) async {
    if (index < 0) {
      throw ArgumentError('Index must be non-negative');
    }
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
    await _repository.updateQuantity(index, quantity);
  }
}

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<void> execute() async {
    await _repository.clearCart();
  }
}

class GetCartItemsUseCase {
  final CartRepository _repository;

  GetCartItemsUseCase(this._repository);

  Future<List<CartItem>> execute() async {
    return await _repository.getCartItems();
  }
}

class GetCartTotalUseCase {
  final CartRepository _repository;

  GetCartTotalUseCase(this._repository);

  Future<double> execute() async {
    return await _repository.getCartTotal();
  }
}

class GetCartItemsCountUseCase {
  final CartRepository _repository;

  GetCartItemsCountUseCase(this._repository);

  Future<int> execute() async {
    return await _repository.getCartItemsCount();
  }
}
