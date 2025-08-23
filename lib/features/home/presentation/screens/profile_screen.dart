import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/shared/widgets/widgets.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/features/auth/data/user_service.dart';
import 'package:chanzel/features/auth/domain/models/user_model.dart';

class IconsManger {
  static const IconData edit = Icons.edit_note_rounded;
  static const IconData payment = Icons.payment_rounded;
  static const IconData orders = Icons.list_alt_rounded;
  static const IconData setting = Icons.settings_outlined;
  static const IconData home = Icons.home_outlined;
  static const IconData cart = Icons.shopping_cart_outlined;
  static const IconData bag = Icons.shopping_bag_outlined;
  static const IconData profile_selected = Icons.person;
}
// -----------------------------------------

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userData;
  String? _userPhotoBase64;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when dependencies change (e.g., when returning from edit profile)
    _loadUserData();
  }

  /// Loads user data and photo
  Future<void> _loadUserData() async {
    try {
      print('ProfileScreen: Loading user data...');
      final user = await _userService.loadUserData();
      final photoBase64 = await _userService.loadUserPhotoBase64();

      print('ProfileScreen: User data loaded: ${user?.name}');
      if (mounted) {
        setState(() {
          _userData = user;
          _userPhotoBase64 = photoBase64;
        });
      }
    } catch (e) {
      print('ProfileScreen: Error loading user data: $e');
      // App can work without user data
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Profile', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildProfileIcon(),
              const SizedBox(height: 48),
              _buildProfileOptionTile(
                icon: IconsManger.edit,
                text: 'Edit Profile',
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/editProfile',
                  );
                  // Refresh user data when returning from edit profile
                  if (result == true) {
                    _loadUserData();
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionTile(
                icon: IconsManger.payment,
                text: 'Payment Method',
                onTap: () {
                  ToastService.showFeatureComingSoon(context);
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionTile(
                icon: IconsManger.orders,
                text: 'My orders',
                onTap: () {
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionTile(
                icon: IconsManger.setting,
                text: 'Setting',
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              const SizedBox(height: 12),
              _buildProfileOptionTile(
                icon: Icons.gavel,
                text: 'Legal & Copyright',
                onTap: () {
                  _showLegalDialog(context);
                },
              ),
              const SizedBox(height: 32), // Add extra bottom padding
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
    );
  }

  /// Builds the large profile icon with user photo and information.
  Widget _buildProfileIcon() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: ColorsManger.beigeColor,
          backgroundImage: _userPhotoBase64 != null
              ? MemoryImage(base64Decode(_userPhotoBase64!))
              : null,
          child: _userPhotoBase64 == null
              ? const Icon(
                  Icons.person_outline,
                  size: 80,
                  color: ColorsManger.naiveColor,
                )
              : null,
        ),
        const SizedBox(height: 16),
        if (_userData?.name != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _userData!.name!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (_userData?.email != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
            child: Text(
              _userData!.email!,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (_userData?.phone != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
            child: Text(
              'Phone: ${_userData!.phone!}',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (_userData?.address != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${_userData!.address}, Egypt',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Builds a reusable tile for a profile option.
  Widget _buildProfileOptionTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
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

  void _showLegalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.gavel, color: ColorsManger.naiveColor, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Legal & Copyright',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorsManger.naiveColor,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorsManger.naiveColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Abdelrahman Sami',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorsManger.naiveColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All rights reserved.',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This application is the property of Abdelrahman Sami. Unauthorized copying, distribution, or modification of this application is strictly prohibited.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsManger.naiveColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'By using this application, you agree to our terms of service and privacy policy.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsManger.naiveColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your privacy is important to us. We collect and use your information in accordance with our privacy policy.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
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
