import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/data/cart_service.dart';
import 'package:chanzel/shared/utils/toast_service.dart';
import 'package:chanzel/features/home/data/wishlist_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final List<String> _imageUrls;
  final WishlistService _wishlistService = WishlistService();

  @override
  void initState() {
    super.initState();
    // Use the product image for all gallery images
    _imageUrls = List.generate(5, (index) => widget.product.image);
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

  void _toggleWishlist() {
    _wishlistService.toggleWishlist(widget.product);

    final isWishlisted = _wishlistService.isProductWishlisted(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isWishlisted
            ? '${widget.product.name} added to wishlist'
            : '${widget.product.name} removed from wishlist'),
        backgroundColor: isWishlisted ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _isProductWishlisted() {
    return _wishlistService.isProductWishlisted(widget.product);
  }

  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL', 'XXXXL'];

  int _selectedImageIndex = 0;
  int _selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageGallery(),
              const SizedBox(height: 24),
              _buildProductInfo(),
              const SizedBox(height: 24),
              _buildSizeSelector(),
              const SizedBox(height: 24),
              _buildColorSelector(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// Builds the AppBar for the screen.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: const CustomBackButton(),
      title: const Text(
        "Product Details",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isProductWishlisted() ? Icons.favorite : Icons.favorite_border,
            color: _isProductWishlisted() ? Colors.red : Colors.grey,
            size: 28,
          ),
          onPressed: _toggleWishlist,
        ),
      ],
    );
  }

  /// Builds the main image and thumbnail gallery.
  Widget _buildImageGallery() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Main Image
          Image.network(
            _imageUrls[_selectedImageIndex],
            fit: BoxFit.cover,
            height: 400,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 400,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 400,
                width: double.infinity,
                color: Theme.of(context).colorScheme.surface,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading image...',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Thumbnails
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_imageUrls.length, (index) {
                return _buildThumbnail(index);
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper for a single thumbnail image.
  Widget _buildThumbnail(int index) {
    bool isSelected = _selectedImageIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedImageIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ColorsManger.naiveColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            _imageUrls[index],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Theme.of(context).colorScheme.surface,
                child: Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 16,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 50,
                height: 50,
                color: Theme.of(context).colorScheme.surface,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 1),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the product information section.
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Category',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.product.rating.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Divider(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ],
    );
  }

  /// Builds the size selection chips.
  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(_sizes.length, (index) {
            return _buildSizeChip(index);
          }),
        ),
      ],
    );
  }

  /// Helper for a single size chip.
  Widget _buildSizeChip(int index) {
    bool isSelected = _selectedSizeIndex == index;
    return ChoiceChip(
      label: Text(_sizes[index]),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSizeIndex = index;
        });
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: ColorsManger.naiveColor,
      labelStyle: TextStyle(
        color:
            isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(
        color: isSelected
            ? Colors.transparent
            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  /// Builds the color selection section.
  Widget _buildColorSelector() {
    return Row(
      children: [
        Text(
          'Select Color :',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Naïve',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  /// Builds the bottom bar with price and "Add to Cart" button.
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total price',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.price,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              final cartService = CartService();
              cartService.addToCart(widget.product,
                  size: _sizes[_selectedSizeIndex]);

              ToastService.showSuccess(
                context,
                '${widget.product.name} added to cart!',
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            label: const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A), // Dark blue color
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
