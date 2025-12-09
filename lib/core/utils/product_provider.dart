import 'package:flutter/foundation.dart';
import '../../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _recentlyViewed = [];
  List<ProductModel> _wishlist = [];
  bool _isLoading = false;
  
  List<ProductModel> get products => _products;
  List<ProductModel> get recentlyViewed => _recentlyViewed;
  List<ProductModel> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  
  ProductProvider() {
    _initializeDummyData();
  }
  
  void _initializeDummyData() {
    _products = [
      ProductModel(
        id: '1',
        name: 'Premium Wireless Headphones',
        description: 'High-quality wireless headphones with noise cancellation and 30-hour battery life.',
        price: 2999.00,
        originalPrice: 4999.00,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1487215078519-e21cc028cb29?w=500&h=500&fit=crop',
        ],
        category: 'Electronics',
        brand: 'SoundMax',
        rating: 4.5,
        reviewCount: 234,
        inStock: true,
        sizes: [],
        colors: ['Black', 'Silver', 'Blue'],
        tags: ['trending', 'bestseller'],
        availableQuantity: 50,
        storeLocation: 'Main Street Store',
      ),
      ProductModel(
        id: '2',
        name: 'Cotton Casual T-Shirt',
        description: 'Comfortable 100% cotton t-shirt perfect for everyday wear.',
        price: 599.00,
        originalPrice: 999.00,
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500&h=500&fit=crop',
        ],
        category: 'Fashion',
        brand: 'FashionHub',
        rating: 4.2,
        reviewCount: 156,
        inStock: true,
        sizes: ['S', 'M', 'L', 'XL', 'XXL'],
        colors: ['White', 'Black', 'Navy', 'Red'],
        tags: ['new'],
        availableQuantity: 100,
        storeLocation: 'Downtown Store',
      ),
      ProductModel(
        id: '3',
        name: 'Smart Watch Series 5',
        description: 'Feature-rich smartwatch with fitness tracking, heart rate monitor, and 5-day battery.',
        price: 4499.00,
        originalPrice: 6999.00,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=500&h=500&fit=crop',
        ],
        category: 'Electronics',
        brand: 'TechWear',
        rating: 4.7,
        reviewCount: 389,
        inStock: true,
        sizes: ['38mm', '42mm'],
        colors: ['Black', 'Silver', 'Gold', 'Rose Gold'],
        tags: ['trending', 'bestseller'],
        availableQuantity: 75,
        storeLocation: 'Tech Mall Store',
      ),
      ProductModel(
        id: '4',
        name: 'Running Shoes Pro',
        description: 'Professional running shoes with advanced cushioning and breathable mesh upper.',
        price: 3499.00,
        originalPrice: 5999.00,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500&h=500&fit=crop',
        ],
        category: 'Sports & Outdoors',
        brand: 'SportFit',
        rating: 4.6,
        reviewCount: 278,
        inStock: true,
        sizes: ['6', '7', '8', '9', '10', '11'],
        colors: ['Black', 'White', 'Blue', 'Red'],
        tags: ['bestseller'],
        availableQuantity: 60,
        storeLocation: 'Sports Complex Store',
      ),
      ProductModel(
        id: '5',
        name: 'Coffee Maker Deluxe',
        description: 'Programmable coffee maker with 12-cup capacity and auto-brew feature.',
        price: 2799.00,
        originalPrice: 3999.00,
        imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1580402054860-a9a8c8c7f650?w=500&h=500&fit=crop',
        ],
        category: 'Home & Kitchen',
        brand: 'HomeEssentials',
        rating: 4.3,
        reviewCount: 145,
        inStock: true,
        sizes: [],
        colors: ['Black', 'Silver'],
        tags: ['new'],
        availableQuantity: 40,
        storeLocation: 'Home Store',
      ),
      ProductModel(
        id: '6',
        name: 'Moisturizing Face Cream',
        description: 'Hydrating face cream with vitamin E and natural ingredients for all skin types.',
        price: 899.00,
        originalPrice: 1499.00,
        imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500&h=500&fit=crop',
        ],
        category: 'Beauty & Personal Care',
        brand: 'GlowSkin',
        rating: 4.4,
        reviewCount: 567,
        inStock: true,
        sizes: ['50ml', '100ml'],
        colors: [],
        tags: ['bestseller'],
        availableQuantity: 120,
        storeLocation: 'Beauty Store',
      ),
      ProductModel(
        id: '7',
        name: 'Bestselling Novel Collection',
        description: 'Collection of 3 bestselling novels by award-winning authors.',
        price: 1299.00,
        originalPrice: 1999.00,
        imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=500&h=500&fit=crop',
        ],
        category: 'Books',
        brand: 'ReadMore Publishing',
        rating: 4.8,
        reviewCount: 892,
        inStock: true,
        sizes: [],
        colors: [],
        tags: ['trending', 'bestseller'],
        availableQuantity: 200,
        storeLocation: 'Book Store',
      ),
      ProductModel(
        id: '8',
        name: 'Kids Educational Toy Set',
        description: 'Interactive educational toy set for kids aged 3-8 years.',
        price: 1599.00,
        originalPrice: 2499.00,
        imageUrl: 'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=500&h=500&fit=crop',
        images: [
          'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=500&h=500&fit=crop',
          'https://images.unsplash.com/photo-1587912781127-74a0935396b4?w=500&h=500&fit=crop',
        ],
        category: 'Toys & Games',
        brand: 'PlayLearn',
        rating: 4.5,
        reviewCount: 423,
        inStock: true,
        sizes: [],
        colors: ['Multicolor'],
        tags: ['new'],
        availableQuantity: 80,
        storeLocation: 'Kids Store',
      ),
    ];
    
    _recentlyViewed = _products.take(3).toList();
  }
  
  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }
  
  List<ProductModel> getTrendingProducts() {
    return _products.where((p) => p.tags.contains('trending')).toList();
  }
  
  List<ProductModel> getBestSellers() {
    return _products.where((p) => p.tags.contains('bestseller')).toList();
  }
  
  List<ProductModel> getNewArrivals() {
    return _products.where((p) => p.tags.contains('new')).toList();
  }
  
  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  
  void addToRecentlyViewed(ProductModel product) {
    _recentlyViewed.removeWhere((p) => p.id == product.id);
    _recentlyViewed.insert(0, product);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.take(10).toList();
    }
    notifyListeners();
  }
  
  void toggleWishlist(ProductModel product) {
    final index = _wishlist.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }
  
  bool isInWishlist(String productId) {
    return _wishlist.any((p) => p.id == productId);
  }
  
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    final lowerQuery = query.toLowerCase();
    return _products.where((p) => 
      p.name.toLowerCase().contains(lowerQuery) ||
      p.description.toLowerCase().contains(lowerQuery) ||
      p.category.toLowerCase().contains(lowerQuery) ||
      p.brand.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
