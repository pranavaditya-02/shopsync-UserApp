import 'package:flutter/foundation.dart';
import '../../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> _items = [];
  
  List<CartItemModel> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  
  double get deliveryFee => subtotal > 0 ? 50.0 : 0.0;
  
  double get total => subtotal + deliveryFee;
  
  void addToCart({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    String? selectedSize,
    String? selectedColor,
  }) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.productId == productId &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(
        CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          productName: productName,
          productImage: productImage,
          price: price,
          quantity: 1,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
        ),
      );
    }
    notifyListeners();
  }
  
  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }
  
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }
}
