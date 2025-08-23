import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';
import 'package:chanzel/features/home/domain/models/product.dart';
import 'package:chanzel/features/home/presentation/screens/product_screen.dart';
import 'package:chanzel/features/home/data/wishlist_service.dart';
import 'package:chanzel/shared/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WishlistService _wishlistService = WishlistService();
  // Product data using Product model - same as home screen
  final List<Product> _products = [
    // Men's Products
    const Product(
      name: 'Black Jacket',
      price: '690 LE',
      image: 'https://i.postimg.cc/9XpKBdpt/Group-35-1.png',
      description:
          'A sleek black leather jacket that adds a bold, edgy look to any outfit.',
      rating: 4.5,
    ),
    const Product(
      name: 'Brown T-Shirt',
      price: '599 LE',
      image: 'https://i.postimg.cc/hjC8XtLx/Group-35-2.png',
      description:
          'A comfortable brown T-shirt with a subtle pattern, perfect for everyday casual wear.',
      rating: 4.0,
    ),
    const Product(
      name: 'Naïve Jacket',
      price: '899 LE',
      image: 'https://i.postimg.cc/KvdXHnKK/Group-35-3.png',
      description:
          'A sophisticated dark blue textured jacket that combines elegance with comfort.',
      rating: 4.8,
    ),

    // Women's Products
    const Product(
      name: 'White Dress',
      price: '1999 LE',
      image: 'https://i.postimg.cc/TY3XZdYb/Group-35-1.png',
      description:
          'An elegant white dress perfect for special occasions and summer events.',
      rating: 4.7,
    ),
    const Product(
      name: 'Beige Jacket',
      price: '960 LE',
      image: 'https://i.postimg.cc/wjN4rZJJ/Group-35-2.png',
      description:
          'A sophisticated beige jacket that adds warmth and style to any outfit.',
      rating: 4.6,
    ),
    const Product(
      name: 'Green Jacket',
      price: '790 LE',
      image: 'https://i.postimg.cc/LsRDbXmK/Group-35-4.png',
      description: 'A trendy green jacket that makes a bold fashion statement.',
      rating: 4.4,
    ),

    // Kids' Products
    const Product(
      name: 'Black Dress',
      price: '790 LE',
      image: 'https://i.postimg.cc/R0ZNNQXs/Group-35-1.png',
      description:
          'A stylish black dress perfect for kids\' special occasions and parties.',
      rating: 4.0,
    ),
    const Product(
      name: 'Beige T-Shirt',
      price: '460 LE',
      image: 'https://i.postimg.cc/tCdTkmcv/Group-35-2.png',
      description:
          'A comfortable beige t-shirt made from soft, child-friendly fabric.',
      rating: 5.0,
    ),
    const Product(
      name: 'Beige Jacket',
      price: '790 LE',
      image: 'https://i.postimg.cc/Px8fw6Z4/Group-35-4.png',
      description: 'A warm and cozy beige jacket perfect for cooler weather.',
      rating: 5.0,
    ),
    const Product(
      name: 'White Dress',
      price: '699 LE',
      image: 'https://i.postimg.cc/zXkzKHL9/Group-35-5.png',
      description:
          'A beautiful white dress that makes any child look adorable.',
      rating: 4.0,
    ),
    const Product(
      name: 'White T-Shirt',
      price: '360 LE',
      image: 'https://i.postimg.cc/XYHnDMkL/Group-35-6.png',
      description:
          'A clean white t-shirt that goes with everything in a child\'s wardrobe.',
      rating: 3.5,
    ),
  ];
  List<Product> _filteredProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
    _searchController.addListener(_onSearchChanged);
    _wishlistService.addListener(_onWishlistChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _wishlistService.removeListener(_onWishlistChanged);
    super.dispose();
  }

  void _onWishlistChanged() {
    setState(() {
      // Trigger rebuild when wishlist changes
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query) ||
              product.price.toLowerCase().contains(query);
        }).toList();
      }
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
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_wishlistService.wishlistCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
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
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isSearching && _filteredProducts.isEmpty
                ? _buildNoResults()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.tune,
                size: 24, color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    final isWishlisted = _isProductWishlisted(product);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Theme.of(context).colorScheme.surface,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 24),
                                SizedBox(height: 4),
                                Text(
                                  'Error',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.6),
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.price,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsManger.naiveColor,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  product.rating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Heart icon positioned at top right
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.1),
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
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
