import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/features/home/data/promo_service.dart';
import 'package:chanzel/features/home/presentation/screens/addres_screen.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

// --- Placeholder for Icon Manager ---
class IconsManger {
  static const IconData location = Icons.location_on_outlined;
  static const IconData shipping = Icons.local_shipping_outlined;
}
// -----------------------------------------

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService _cartService = CartService();
  final PromoService _promoService = PromoService();
  List<CartItem> _orderItems = [];
  Address _selectedAddress = Address(
    title: 'Home',
    details: '123 Main Street, Cairo, Egypt',
  );
  bool _isLoading = false;

  static const double shippingFee = 50.0; // Updated shipping fee

  @override
  void initState() {
    super.initState();
    _loadOrderItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadOrderItems();
  }

  void _loadOrderItems() {
    setState(() {
      _orderItems = _cartService.cartItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if cart is empty
    if (_orderItems.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some items to your cart to proceed with checkout',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              title: 'Shipping Address',
              icon: IconsManger.location,
              line1: _selectedAddress.title,
              line2: _selectedAddress.details,
            ),
            _buildDivider(),
            _buildInfoSection(
              title: 'Choose Shipping',
              icon: IconsManger.shipping,
              line1: 'Economy',
              line2: 'economy',
            ),
            _buildDivider(),
            _buildOrderList(),
            _buildDivider(),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildProceedToPaymentButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Checkout', style: theme.appBarTheme.titleTextStyle),
      centerTitle: true,
    );
  }

  /// Builds a reusable section for displaying information like address or shipping.
  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required String line1,
    required String line2,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      line2,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShippingAddressScreen(),
                    ),
                  );
                  if (result != null && result is Address) {
                    setState(() {
                      _selectedAddress = result;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  foregroundColor: theme.colorScheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('CHANGE'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the list of items in the order.
  Widget _buildOrderList() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _orderItems.length,
          itemBuilder: (context, index) {
            return _buildOrderItemCard(_orderItems[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        ),
      ],
    );
  }

  /// Builds a card for a single item in the order list.
  Widget _buildOrderItemCard(CartItem item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 24,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.grey[400]! : Colors.grey[600]!,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Size: ${item.size}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.product.price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the order summary section.
  Widget _buildOrderSummary() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(
            'Sub Total',
            '${_cartService.totalPrice.toStringAsFixed(0)} LE',
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Shipping fees',
            '${shippingFee.toStringAsFixed(0)} LE',
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Discount',
            _promoService.appliedPromoCode != null
                ? '-${_promoService.discountAmount.toStringAsFixed(0)} LE'
                : '0 LE',
            isDark: isDark,
            isDiscount: _promoService.appliedPromoCode != null,
          ),
          if (_promoService.appliedPromoCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Applied: ${_promoService.appliedPromoCode!.toUpperCase()} (${_promoService.discountPercentage}% off)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          _buildSummaryRow(
            'Total',
            '${_promoService.calculateTotal(_cartService.totalPrice, shippingFee).toStringAsFixed(0)} LE',
            isTotal: true,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// Helper for a single row in the payment summary.
  Widget _buildSummaryRow(
    String title,
    String amount, {
    bool isTotal = false,
    bool isDark = false,
    bool isDiscount = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal
                ? theme.colorScheme.onSurface
                : (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount
                ? Colors.green
                : (isTotal
                      ? theme.colorScheme.onSurface
                      : (isDark ? Colors.grey[400] : Colors.grey[600])),
          ),
        ),
      ],
    );
  }

  /// Builds the "Proceed to Payment" button.
  Widget _buildProceedToPaymentButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              try {
                // Simulate some processing time
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pushNamed(context, '/payment');
              } catch (e) {
                ToastService.showError(
                  context,
                  'Failed to proceed to payment. Please try again.',
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManger.naiveColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Processing...', style: TextStyle(fontSize: 16)),
              ],
            )
          : const Text('Proceed to Payment', style: TextStyle(fontSize: 16)),
    );
  }

  /// Builds a reusable divider.
  Widget _buildDivider() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Divider(
      height: 32,
      thickness: 1,
      color: isDark ? Colors.grey[700] : Colors.grey[300],
    );
  }
}
