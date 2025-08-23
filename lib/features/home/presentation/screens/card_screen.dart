import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/features/home/data/promo_service.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

// --- Placeholder for Icon Manager ---
class IconsManger {
  static const IconData home = Icons.home_outlined;
  static const IconData cart_selected = Icons.shopping_cart;
  static const IconData bag = Icons.shopping_bag_outlined;
  static const IconData discovery = Icons.explore_outlined;
  static const IconData profile = Icons.person_outline;
}
// -----------------------------------------

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final CartService _cartService = CartService();
  final PromoService _promoService = PromoService();
  final TextEditingController _promoController = TextEditingController();
  List<CartItem> _cartItems = [];

  static const double shippingFee = 50.0; // Updated shipping fee

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCartItems();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _loadCartItems() {
    setState(() {
      _cartItems = _cartService.cartItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItemCard(_cartItems[index]);
              },
            ),
          ),
          _buildOrderSummary(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      title: const Text(
        'My Cart',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  /// Builds a card for a single item in the cart.
  Widget _buildCartItemCard(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.product.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Error',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 100,
                  height: 100,
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size : ${item.size}',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.product.price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Quantity Counter
          _buildQuantityCounter(item),
          // Delete Button
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              _showRemoveConfirmationDialog(context, item);
            },
          ),
        ],
      ),
    );
  }

  /// Builds the interactive quantity counter.
  Widget _buildQuantityCounter(CartItem item) {
    final itemIndex = _cartItems.indexOf(item);
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.remove_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _cartService.updateQuantity(itemIndex, item.quantity - 1);
              _loadCartItems();
            });
          },
        ),
        Text(
          item.quantity.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _cartService.updateQuantity(itemIndex, item.quantity + 1);
              _loadCartItems();
            });
          },
        ),
      ],
    );
  }

  /// Shows a confirmation dialog before removing an item from cart.
  void _showRemoveConfirmationDialog(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Item',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            'Are you sure you want to remove ${item.product.name} from your cart?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final removedItem = item;
                setState(() {
                  _cartService.removeFromCart(_cartItems.indexOf(item));
                  _loadCartItems();
                });
                ToastService.showInfo(
                  context,
                  '${removedItem.product.name} removed from cart',
                );
              },
              child: Text(
                'Remove',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the order summary section at the bottom.
  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPromoCodeField(),
          const SizedBox(height: 20),
          _buildPriceRow(
            'Sub Total',
            '${_cartService.totalPrice.toStringAsFixed(0)} LE',
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            'shipping fees',
            '${shippingFee.toStringAsFixed(0)} LE',
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Discount',
            '${_promoService.discountAmount.toStringAsFixed(0)} LE',
          ),
          Divider(
            height: 32,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          _buildPriceRow(
            'Total',
            '${_promoService.calculateTotal(_cartService.totalPrice, shippingFee).toStringAsFixed(0)} LE',
            isTotal: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _cartItems.isEmpty
                ? null
                : () {
                    Navigator.pushNamed(context, '/checkout');
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManger.naiveColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Proceed to CheckOut',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the promo code input field and button.
  Widget _buildPromoCodeField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _promoController,
            decoration: InputDecoration(
              hintText: 'Promo Code',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: _promoService.appliedPromoCode != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _promoService.removePromoCode();
                          _promoController.clear();
                        });
                        ToastService.showSuccess(context, 'Promo code removed');
                      },
                    )
                  : null,
            ),
            enabled: _promoService.appliedPromoCode == null,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _promoService.appliedPromoCode != null
              ? null
              : () {
                  final promoCode = _promoController.text.trim();
                  if (promoCode.isEmpty) {
                    ToastService.showError(
                      context,
                      'Please enter a promo code',
                    );
                    return;
                  }

                  final success = _promoService.applyPromoCode(
                    promoCode,
                    _cartService.totalPrice,
                  );
                  if (success) {
                    setState(() {});
                    ToastService.showSuccess(
                      context,
                      'Promo code applied! ${_promoService.discountPercentage}% discount',
                    );
                  } else {
                    ToastService.showError(context, 'Invalid promo code');
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManger.naiveColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _promoService.appliedPromoCode != null ? 'Applied' : 'Apply',
          ),
        ),
        if (_promoService.appliedPromoCode != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Applied: ${_promoService.appliedPromoCode!.toUpperCase()} (${_promoService.discountPercentage}% off)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  /// Helper for a single row in the price summary.
  Widget _buildPriceRow(String title, String amount, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 18 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isTotal
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(amount, style: style),
      ],
    );
  }
}
