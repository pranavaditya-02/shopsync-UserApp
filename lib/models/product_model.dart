class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final List<String> sizes;
  final List<String> colors;
  final List<String> tags;
  final int availableQuantity;
  final String storeLocation;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    required this.sizes,
    required this.colors,
    required this.tags,
    required this.availableQuantity,
    required this.storeLocation,
  });

  double get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice! * 100);
    }
    return 0;
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'sizes': sizes,
      'colors': colors,
      'tags': tags,
      'availableQuantity': availableQuantity,
      'storeLocation': storeLocation,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      images: List<String>.from(json['images']),
      category: json['category'],
      brand: json['brand'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      inStock: json['inStock'],
      sizes: List<String>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
      tags: List<String>.from(json['tags']),
      availableQuantity: json['availableQuantity'],
      storeLocation: json['storeLocation'],
    );
  }
}
