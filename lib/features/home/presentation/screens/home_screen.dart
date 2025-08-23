import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/core/services/theme_service.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/presentation/screens/product_screen.dart';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/features/auth/data/user_service.dart';
import 'package:chanzel/features/auth/domain/models/user_model.dart';
import 'package:chanzel/features/home/data/wishlist_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedNavIndex = 0;
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = [
    'All',
    'Dresses',
    'Jacket',
    'T-shirt',
    'Pants',
  ];
  final WishlistService _wishlistService = WishlistService();

  // User data
  UserModel? _userData;
  final UserService _userService = UserService();

  // Dummy data for products
  final List<Product> _products = [
    // Men's Products
    const Product(
      name: 'Black Jacket',
      price: '690 LE',
      image: 'https://i.postimg.cc/9XpKBdpt/Group-35-1.png',
      description:
          'A sleek black leather jacket that adds a bold, edgy look to any outfit.',
    ),
    const Product(
      name: 'Brown T-Shirt',
      price: '599 LE',
      image: 'https://i.postimg.cc/hjC8XtLx/Group-35-2.png',
      description:
          'A comfortable brown T-shirt with a subtle pattern, perfect for everyday casual wear.',
    ),
    const Product(
      name: 'Naïve Jacket',
      price: '899 LE',
      image: 'https://i.postimg.cc/KvdXHnKK/Group-35-3.png',
      description:
          'A sophisticated dark blue textured jacket that combines elegance with comfort.',
    ),

    // Women's Products
    const Product(
      name: 'White Dress',
      price: '1999 LE',
      image: 'https://i.postimg.cc/TY3XZdYb/Group-35-1.png',
      description:
          'An elegant white dress perfect for special occasions and summer events.',
    ),
    const Product(
      name: 'Beige Jacket',
      price: '960 LE',
      image: 'https://i.postimg.cc/wjN4rZJJ/Group-35-2.png',
      description:
          'A sophisticated beige jacket that adds warmth and style to any outfit.',
    ),
    const Product(
      name: 'Green Jacket',
      price: '790 LE',
      image: 'https://i.postimg.cc/LsRDbXmK/Group-35-4.png',
      description: 'A trendy green jacket that makes a bold fashion statement.',
    ),

    // Kids' Products
    const Product(
      name: 'Black Dress',
      price: '790 LE',
      image: 'https://i.postimg.cc/R0ZNNQXs/Group-35-1.png',
      description:
          'A stylish black dress perfect for kids\' special occasions and parties.',
    ),
    const Product(
      name: 'Beige T-Shirt',
      price: '460 LE',
      image: 'https://i.postimg.cc/tCdTkmcv/Group-35-2.png',
      description:
          'A comfortable beige t-shirt made from soft, child-friendly fabric.',
    ),
    const Product(
      name: 'Beige Jacket',
      price: '790 LE',
      image: 'https://i.postimg.cc/Px8fw6Z4/Group-35-4.png',
      description: 'A warm and cozy beige jacket perfect for cooler weather.',
    ),
    const Product(
      name: 'White Dress',
      price: '699 LE',
      image: 'https://i.postimg.cc/zXkzKHL9/Group-35-5.png',
      description:
          'A beautiful white dress that makes any child look adorable.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _wishlistService.addListener(_onWishlistChanged);
  }

  @override
  void dispose() {
    _wishlistService.removeListener(_onWishlistChanged);
    super.dispose();
  }

  void _onWishlistChanged() {
    setState(() {
      // Trigger rebuild when wishlist changes
    });
  }

  void _toggleWishlist(Product product) {
    _wishlistService.toggleWishlist(product);

    final isWishlisted = _wishlistService.isProductWishlisted(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isWishlisted
              ? '${product.name} added to wishlist'
              : '${product.name} removed from wishlist',
        ),
        backgroundColor: isWishlisted ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _isProductWishlisted(Product product) {
    return _wishlistService.isProductWishlisted(product);
  }

  /// Loads user data for display
  Future<void> _loadUserData() async {
    try {
      print('HomeScreen: Loading user data...');
      final user = await _userService.loadUserData();
      print('HomeScreen: User data loaded: ${user?.name}');
      if (mounted) {
        setState(() {
          _userData = user;
        });
      }
    } catch (e) {
      print('HomeScreen: Error loading user data: $e');
      // App can work without user data
    }

    /// Builds the copyright footer
    Widget _buildCopyrightFooter() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: ColorsManger.naiveColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text(
              '© 2025 Abdelrahman Sami',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ColorsManger.naiveColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'All rights reserved',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildNewCollectionsCard(),
                const SizedBox(height: 24),
                _buildCategorySection(),
                const SizedBox(height: 24),
                _buildFilterChips(),
                const SizedBox(height: 24),
                _buildProductGrid(),
                const SizedBox(height: 32),
                _buildCopyrightFooter(),
                const SizedBox(height: 32), // Add extra bottom padding
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  /// Builds the custom AppBar.
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
                Text(
                  _userData?.name ?? 'Guest',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 28),
          onPressed: () {
            ToastService.showFeatureComingSoon(context);
          },
        ),
        const SizedBox(width: 8),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            if (CartService().totalItems > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: ColorsManger.naiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${CartService().totalItems}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
        if (_wishlistService.wishlistCount > 0)
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red, size: 28),
                onPressed: () {
                  Navigator.pushNamed(context, '/wishlist');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${_wishlistService.wishlistCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(width: 8),
        Consumer<ThemeService>(
          builder: (context, themeService, child) {
            return IconButton(
              icon: Icon(
                themeService.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 28,
              ),
              onPressed: () {
                themeService.toggleTheme();
              },
            );
          },
        ),
      ],
    );
  }

  /// Builds the Search Bar with a filter icon.
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12), // Reduced from 16 to 12
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              ToastService.showFeatureComingSoon(context);
            },
            child: Icon(
              Icons.tune,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the "New Collection" promotional card.
  Widget _buildNewCollectionsCard() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManger.naiveColor,
            ColorsManger.naiveColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover the latest trends',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Category section with icons.
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                ToastService.showFeatureComingSoon(context);
              },
              child: Text(
                'See all',
                style: TextStyle(color: ColorsManger.naiveColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Use MainAxisAlignment.spaceEvenly to distribute categories evenly
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/mens_screen');
              },
              child: _buildCategoryItem(
                imageUrl: 'https://i.postimg.cc/44YBSyrq/man-1-1.png',
                label: "Men's",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/womans_screen');
              },
              child: _buildCategoryItem(
                imageUrl: 'https://i.postimg.cc/kMRvyZSd/woman-1-1.png',
                label: "Women's",
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/kids_screen');
              },
              child: _buildCategoryItem(
                imageUrl: 'https://i.postimg.cc/BQWc7g5P/children-1-1.png',
                label: "Kids'",
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Helper for a single category item.
  static Widget _buildCategoryItem({
    required String imageUrl,
    required String label,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: ColorsManger.beigeColor,
          child: ClipOval(
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: 30,
                  color: ColorsManger.naiveColor,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 30,
                  height: 30,
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
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  /// Builds the filter chips for product categories.
  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ), // Add horizontal padding
        itemCount: _chipLabels.length,
        itemBuilder: (context, index) {
          return _buildFilterChip(
            label: _chipLabels[index],
            isSelected: _selectedChipIndex == index,
            onTap: () {
              setState(() {
                _selectedChipIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  /// Helper for a single filter chip.
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected
              ? ColorsManger.naiveColor
              : Theme.of(context).colorScheme.surface,
          labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? ColorsManger.naiveColor
                  : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the grid of product items.
  Widget _buildProductGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth > 400
                ? 0.7
                : 0.8, // Responsive aspect ratio
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: _buildProductItem(product: product),
            );
          },
        );
      },
    );
  }

  /// Builds the copyright footer
  Widget _buildCopyrightFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? ColorsManger.naiveColor.withOpacity(0.15)
            : ColorsManger.naiveColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? ColorsManger.naiveColor.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '© 2025 Abdelrahman Sami',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? ColorsManger.naiveColor
                  : ColorsManger.naiveColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'All rights reserved',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Helper for a single product item card.
  Widget _buildProductItem({required Product product}) {
    final isWishlisted = _isProductWishlisted(product);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 8),
                                Text(
                                  'Loading...',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: ${product.image}');
                        print('Error: $error');
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Image Error',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Heart icon positioned at top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () => _toggleWishlist(product),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.price,
                  style: const TextStyle(
                    color: ColorsManger.naiveColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
