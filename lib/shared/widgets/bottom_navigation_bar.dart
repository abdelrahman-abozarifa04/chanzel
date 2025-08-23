import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8), // Reduced from 16 to 8
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // Reduced vertical padding from 10 to 8
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context,
            selectedImage:
                'https://i.postimg.cc/ZqsSbX7R/home-agreement-2-1.png',
            unselectedImage:
                'https://i.postimg.cc/65vDs8xy/home-agreement-1.png',
            isSelected: currentIndex == 0,
            onTap: () => _navigateToScreen(context, '/home'),
          ),
          _buildNavItem(
            context,
            selectedImage: 'https://i.postimg.cc/wT5Yy1fn/wishlist-1-1.png',
            unselectedImage: 'https://i.postimg.cc/9X7h28Gm/wishlist-2-1.png',
            isSelected: currentIndex == 1,
            onTap: () => _navigateToScreen(context, '/wishlist'),
          ),
          _buildNavItem(
            context,
            selectedImage:
                'https://i.postimg.cc/brCYKd76/online-shopping-1-1.png',
            unselectedImage:
                'https://i.postimg.cc/437cwR9k/online-shopping-2.png',
            isSelected: currentIndex == 2,
            onTap: () => _navigateToScreen(context, '/cart'),
          ),
          _buildNavItem(
            context,
            selectedImage:
                'https://i.postimg.cc/pLykN7Fk/technical-support-1-1.png',
            unselectedImage:
                'https://i.postimg.cc/BvrmBgtp/technical-support-3.png',
            isSelected: currentIndex == 3,
            onTap: () => _navigateToScreen(context, '/settings'),
          ),
          _buildNavItem(
            context,
            selectedImage: 'https://i.postimg.cc/vHbSK3hS/user-1-1.png',
            unselectedImage: 'https://i.postimg.cc/WpMHSQGk/user-2-2.png',
            isSelected: currentIndex == 4,
            onTap: () => _navigateToScreen(context, '/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String selectedImage,
    required String unselectedImage,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // In dark mode, switch the images for better contrast
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final displayImage = isSelected
        ? (isDarkMode ? unselectedImage : selectedImage)
        : (isDarkMode ? selectedImage : unselectedImage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8), // Reduced from 12 to 8
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A3663) : Colors.transparent,
          borderRadius: BorderRadius.circular(16), // Increased border radius
        ),
        child: Image.network(
          displayImage,
          width: 24, // Reduced from 28 to 24
          height: 24, // Reduced from 28 to 24
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
              size: 24, // Reduced from 28 to 24
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 24, // Reduced from 28 to 24
              height: 24, // Reduced from 28 to 24
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String routeName) {
    // Don't navigate if we're already on the current screen
    if (ModalRoute.of(context)?.settings.name == routeName) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false, // Clear the navigation stack
    );
  }
}
