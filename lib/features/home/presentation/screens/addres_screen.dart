import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

// --- Placeholder for Icon Manager ---
class IconsManger {
  static const IconData location = Icons.location_on_outlined;
  static const IconData add = Icons.add;
}
// -----------------------------------------

// A simple data model for a shipping address
class Address {
  final String title;
  final String details;

  Address({required this.title, required this.details});
}

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  // Dummy data for shipping addresses
  final List<Address> _addresses = [
    Address(title: 'Home', details: '123 Main Street, Cairo, Egypt'),
    Address(title: 'Office', details: '456 Business Ave, Cairo, Egypt'),
    Address(title: 'Other', details: '789 Side Street, Cairo, Egypt'),
  ];

  int _selectedAddressIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  return _buildAddressTile(_addresses[index], index);
                },
                separatorBuilder: (context, index) => Divider(
                  height: 24,
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
            ),
            _buildAddNewAddressButton(),
            const SizedBox(height: 24),
            _buildApplyButton(),
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
      title: Text('Add Address', style: theme.appBarTheme.titleTextStyle),
      centerTitle: true,
    );
  }

  /// Builds a selectable tile for a single address.
  Widget _buildAddressTile(Address address, int index) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(
        IconsManger.location,
        color: ColorsManger.naiveColor,
        size: 28,
      ),
      title: Text(
        address.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        address.details,
        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: Radio<int>(
        value: index,
        groupValue: _selectedAddressIndex,
        onChanged: (int? value) {
          setState(() {
            _selectedAddressIndex = value!;
          });
        },
        activeColor: ColorsManger.naiveColor,
      ),
      onTap: () {
        setState(() {
          _selectedAddressIndex = index;
        });
      },
    );
  }

  /// Builds the "Add New Address" button.
  Widget _buildAddNewAddressButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Navigate to add new address screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add new address functionality coming soon!'),
          ),
        );
      },
      icon: const Icon(IconsManger.add, color: Colors.white),
      label: const Text('Add New Address'),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManger.naiveColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Builds the final "Apply" button.
  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {
        // Return the selected address to the checkout screen
        final selectedAddress = _addresses[_selectedAddressIndex];
        Navigator.of(context).pop(selectedAddress);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManger.naiveColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Apply', style: TextStyle(fontSize: 16)),
    );
  }
}
