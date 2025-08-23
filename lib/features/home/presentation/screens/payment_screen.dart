import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/features/home/data/order_service.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

// --- Placeholder for Icon Manager ---
class IconsManger {
  static const IconData addCard = Icons.credit_card;
  static const IconData apple = Icons.apple;
  static const IconData google = Icons.android; // Placeholder for Google icon
  static const IconData paypal = Icons
      .payment; // Placeholder, requires a package like font_awesome_flutter
}
// -----------------------------------------

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  bool _isProcessing = false;

  void _completeOrder(BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Create order from cart items
      _orderService.createOrderFromCart(
        _cartService.cartItems,
        '123 Main Street, Cairo, Egypt', // Default address for now
      );

      // Clear the cart
      _cartService.clearCart();

      // Navigate to success screen
      Navigator.pushNamedAndRemoveUntil(context, '/success', (route) => false);
    } catch (e) {
      ToastService.showError(context, 'Payment failed. Please try again.');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check if cart is empty
    if (_cartService.cartItems.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                'Add some items to your cart to proceed with payment',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Credit & Debit Card'),
                const SizedBox(height: 16),
                _buildPaymentOptionTile(
                  icon: IconsManger.addCard,
                  text: 'Add Card',
                  onTap: () {
                    Navigator.pushNamed(context, '/add_card');
                  },
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('More Payment Options'),
                const SizedBox(height: 16),
                _buildPaymentOptionTile(
                  icon: IconsManger.paypal,
                  text: 'Paypal',
                  onTap: _isProcessing
                      ? null
                      : () {
                          _completeOrder(context);
                        },
                ),
                const SizedBox(height: 12),
                _buildPaymentOptionTile(
                  icon: IconsManger.apple,
                  text: 'Apple Pay',
                  onTap: _isProcessing
                      ? null
                      : () {
                          _completeOrder(context);
                        },
                ),
                const SizedBox(height: 12),
                _buildPaymentOptionTile(
                  icon: IconsManger.google,
                  text: 'Google Pay',
                  onTap: _isProcessing
                      ? null
                      : () {
                          _completeOrder(context);
                        },
                ),
                const Spacer(),
                _buildConfirmButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Loading overlay
          if (_isProcessing)
            Container(
              color: theme.colorScheme.surface.withOpacity(0.8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColorsManger.naiveColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Processing Payment...',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Payment', style: theme.appBarTheme.titleTextStyle),
      centerTitle: true,
    );
  }

  /// Builds the title for a section.
  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  /// Builds a reusable tile for a payment option.
  Widget _buildPaymentOptionTile({
    required IconData icon,
    required String text,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: ColorsManger.naiveColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorsManger.beigeColor, size: 28),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorsManger.beigeColor,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: ColorsManger.beigeColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the final "Confirm Payment" button.
  Widget _buildConfirmButton() {
    return Builder(
      builder: (context) => ElevatedButton(
        onPressed: () {
          // This button is for when user has already selected a payment method
          // For now, it will show a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a payment method above'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManger.naiveColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Confirm Payment', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
