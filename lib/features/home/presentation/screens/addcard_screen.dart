import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/features/home/data/order_service.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();

  void _completeOrder(BuildContext context) {
    // Create order from cart items
    final order = _orderService.createOrderFromCart(
      _cartService.cartItems,
      '123 Main Street, Cairo, Egypt', // Default address for now
    );

    // Clear the cart
    _cartService.clearCart();

    // Navigate to success screen
    Navigator.pushNamedAndRemoveUntil(context, '/success', (route) => false);
  }

  @override
  // Controllers to manage the text in the TextFields.
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _saveCard = true;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreditCard(isDark),
            const SizedBox(height: 32),
            _buildCardDetailsForm(isDark),
          ],
        ),
      ),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      title: Text(
        'Add Card',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Builds the interactive credit card widget.
  Widget _buildCreditCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
        color: isDark ? ColorsManger.naiveColor : ColorsManger.naiveColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Placeholder for the abstract line art
              Icon(
                Icons.line_weight,
                size: 40,
                color: isDark
                    ? ColorsManger.beigeColor
                    : ColorsManger.beigeColor,
              ),
              Text(
                "VISA",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: isDark
                      ? ColorsManger.beigeColor
                      : ColorsManger.beigeColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _cardNumberController.text.isEmpty
                ? 'XXXX XXXX XXXX XXXX'
                : _cardNumberController.text,
            style: TextStyle(
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
              color: isDark ? ColorsManger.beigeColor : ColorsManger.beigeColor,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardDetailText(
                'Card Holder Name',
                _cardHolderNameController.text.isEmpty
                    ? 'Your Name'
                    : _cardHolderNameController.text,
                isDark,
              ),
              _buildCardDetailText(
                'Expiry Date',
                _expiryDateController.text.isEmpty
                    ? 'MM/YY'
                    : _expiryDateController.text,
                isDark,
              ),
              Icon(
                Icons.sim_card,
                size: 30,
                color: isDark
                    ? ColorsManger.beigeColor
                    : ColorsManger.beigeColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailText(String title, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? ColorsManger.beigeColor : ColorsManger.beigeColor,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? ColorsManger.beigeColor : ColorsManger.beigeColor,
          ),
        ),
      ],
    );
  }

  /// Builds the form for entering card details.
  Widget _buildCardDetailsForm(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Card Holder Name',
          hint: 'Enter Your Name',
          controller: _cardHolderNameController,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Card Number',
          hint: 'Enter Your Card Number',
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          isDark: isDark,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            CardNumberInputFormatter(),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Expiry Date',
                hint: 'MM/YY',
                controller: _expiryDateController,
                keyboardType: TextInputType.datetime,
                isDark: isDark,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CardMonthInputFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'CVV',
                hint: '123',
                controller: _cvvController,
                keyboardType: TextInputType.number,
                isDark: isDark,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSaveCardCheckbox(isDark),
        const SizedBox(height: 32),
        _buildAddCardButton(),
      ],
    );
  }

  /// A reusable helper method to build styled text input fields.
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey.shade400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[600]! : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: ColorsManger.naiveColor,
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) =>
              setState(() {}), // Rebuild to update the card widget
        ),
      ],
    );
  }

  /// Builds the "Save Card" checkbox.
  Widget _buildSaveCardCheckbox(bool isDark) {
    return Row(
      children: [
        Checkbox(
          value: _saveCard,
          onChanged: (bool? value) {
            setState(() {
              _saveCard = value ?? false;
            });
          },
          activeColor: ColorsManger.naiveColor,
        ),
        Text(
          'Save Card',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Builds the final "Add Card" button.
  Widget _buildAddCardButton() {
    return ElevatedButton(
      onPressed: () {
        // Validate form fields
        if (_cardHolderNameController.text.trim().isEmpty) {
          ToastService.showError(context, 'Please enter card holder name');
          return;
        }
        if (_cardNumberController.text.trim().isEmpty) {
          ToastService.showError(context, 'Please enter card number');
          return;
        }
        if (_expiryDateController.text.trim().isEmpty) {
          ToastService.showError(context, 'Please enter expiry date');
          return;
        }
        if (_cvvController.text.trim().isEmpty) {
          ToastService.showError(context, 'Please enter CVV');
          return;
        }

        // Complete order and navigate to success screen
        _completeOrder(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManger.naiveColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Add Card', style: TextStyle(fontSize: 16)),
    );
  }
}

// Custom formatters for card number and expiry date

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
