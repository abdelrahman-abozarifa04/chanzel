import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/presentation/screens/product_screen.dart';
import 'package:chanzel/features/home/data/wishlist_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

class WomenProductsScreen extends StatefulWidget {
  const WomenProductsScreen({super.key});

  @override
  State<WomenProductsScreen> createState() => _WomenProductsScreenState();
}

class _WomenProductsScreenState extends State<WomenProductsScreen> {
  int _selectedChipIndex = 0;
  final List<String> _chipLabels = ['All', 'jacket', 'T-Shirt', 'Dresses'];
  final WishlistService _wishlistService = WishlistService();

  // Product data using Product model
  final List<Product> _products = [
    const Product(
      name: 'White Dress',
      price: '1999 LE',
      image: 'https://i.postimg.cc/TY3XZdYb/Group-35-1.png',
      description:
          'An elegant white dress perfect for special occasions and summer events.',
      rating: 4.0,
    ),
    const Product(
      name: 'Beige Jacket',
      price: '960 LE',
      image: 'https://i.postimg.cc/wjN4rZJJ/Group-35-2.png',
      description:
          'A sophisticated beige jacket that adds warmth and style to any outfit.',
      rating: 5.0,
    ),
    const Product(
      name: 'Beige T-Shirt',
      price: '799 LE',
      image: 'https://i.postimg.cc/8cstm0N7/Group-35-3.png',
      description:
          'A comfortable and versatile beige t-shirt for everyday wear.',
      rating: 4.5,
    ),
    const Product(
      name: 'Green Jacket',
      price: '790 LE',
      image: 'https://i.postimg.cc/LsRDbXmK/Group-35-4.png',
      description: 'A trendy green jacket that makes a bold fashion statement.',
      rating: 5.0,
    ),
    const Product(
      name: 'Beige Dress',
      price: '2800 LE',
      image: 'https://i.postimg.cc/vBZzGN10/Group-35-5.png',
      description:
          'A luxurious beige dress designed for formal occasions and evening events.',
      rating: 4.0,
    ),
    const Product(
      name: 'Gray Jacket',
      price: '799 LE',
      image: 'https://i.postimg.cc/c1jmNTdc/Group-35-6.png',
      description:
          'A classic gray jacket that offers timeless style and comfort.',
      rating: 3.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
        content: Text(isWishlisted
            ? '${product.name} added to wishlist'
            : '${product.name} removed from wishlist'),
        backgroundColor: isWishlisted ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _isProductWishlisted(Product product) {
    return _wishlistService.isProductWishlisted(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      title: const Text(
        'Women\'s Collection',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Builds the filter chips for product categories.
  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
  Widget _buildFilterChip(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label),
          backgroundColor:
              isSelected ? ColorsManger.naiveColor : ColorsManger.beigeColor,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  /// Builds the grid of product items.
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: _buildProductItem(
            product: product,
          ),
        );
      },
    );
  }

  /// Helper for a single product item card.
  Widget _buildProductItem({
    required Product product,
  }) {
    final isWishlisted = _isProductWishlisted(product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Error builder for when an image fails to load
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  // Loading builder to show a skeleton while the image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.price,
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(product.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
