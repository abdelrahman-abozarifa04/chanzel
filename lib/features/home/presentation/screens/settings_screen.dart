import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/core/services/theme_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/features/auth/data/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class IconsManger {
  static const IconData password = Icons.password_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData home = Icons.home_outlined;
  static const IconData cart = Icons.shopping_cart_outlined;
  static const IconData bag = Icons.shopping_bag_outlined;
  static const IconData setting_selected = Icons.settings;
  static const IconData profile = Icons.person_outline;
  static const IconData theme = Icons.dark_mode;
  static const IconData logout = Icons.logout_rounded;
}
// -----------------------------------------

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Settings', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingOptionTile(
              context: context,
              icon: IconsManger.theme,
              text: 'Theme',
              subtitle: 'Switch between light and dark mode',
              onTap: () {
                // Theme toggle is handled by the switch
              },
              trailing: _buildThemeToggle(context),
            ),
            const SizedBox(height: 12),
            _buildSettingOptionTile(
              context: context,
              icon: IconsManger.password,
              text: 'Password Manager',
              onTap: () {
                ToastService.showFeatureComingSoon(context);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingOptionTile(
              context: context,
              icon: IconsManger.delete,
              text: 'Delete Account',
              onTap: () {
                ToastService.showFeatureComingSoon(context);
              },
            ),
            const SizedBox(height: 12),
            _buildSettingOptionTile(
              context: context,
              icon: Icons.info_outline,
              text: 'About Chanzel',
              subtitle: 'Version 1.0.0',
              onTap: () {
                _showAboutDialog(context);
              },
            ),
            const SizedBox(height: 24), // Extra spacing before logout section
            Container(height: 1, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 24),
            _buildLogoutTile(context),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Switch(
          value: themeService.isDarkMode,
          onChanged: (value) {
            themeService.toggleTheme();
          },
          activeColor: ColorsManger.beigeColor,
          inactiveThumbColor: ColorsManger.beigeColor.withOpacity(0.5),
          inactiveTrackColor: ColorsManger.beigeColor.withOpacity(0.2),
        );
      },
    );
  }

  /// Builds a reusable tile for a setting option.
  Widget _buildSettingOptionTile({
    required BuildContext context,
    required IconData icon,
    required String text,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorsManger.beigeColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorsManger.beigeColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else
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

  Widget _buildLogoutTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showLogoutConfirmationDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(IconsManger.logout, color: Colors.red, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logout',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  const Text(
                    'Log out of your account',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorsManger.naiveColor,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: ColorsManger.naiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                try {
                  final authService = FirebaseAuthService();
                  await authService.signOut();
                  // Navigate to login screen and clear navigation stack
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                } catch (e) {
                  // Show error message if logout fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: ColorsManger.naiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.shopping_bag,
                color: ColorsManger.naiveColor,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Chanzel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsManger.naiveColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'A modern e-commerce application for fashion and clothing retail.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorsManger.naiveColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsManger.naiveColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Copyright © 2025',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ColorsManger.naiveColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Abdelrahman Sami',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorsManger.naiveColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'All rights reserved.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This application is the property of Abdelrahman Sami. Unauthorized copying, distribution, or modification is strictly prohibited.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: ColorsManger.naiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
