class Product {
  final String name;
  final String price;
  final String image;
  final String description;
  final double rating;
  final bool isWishlisted;

  const Product({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    this.rating = 0.0,
    this.isWishlisted = false,
  });

  Product copyWith({
    String? name,
    String? price,
    String? image,
    String? description,
    double? rating,
    bool? isWishlisted,
  }) {
    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'rating': rating,
      'isWishlisted': isWishlisted,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      isWishlisted: map['isWishlisted'] ?? false,
    );
  }

  /// Convert Product to JSON (alias for toMap)
  Map<String, dynamic> toJson() => toMap();

  /// Create Product from JSON (alias for fromMap)
  factory Product.fromJson(Map<String, dynamic> json) => Product.fromMap(json);
}
