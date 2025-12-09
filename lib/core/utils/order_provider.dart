import 'package:flutter/foundation.dart';
import '../../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  
  List<OrderModel> get orders => _orders;
  
  OrderProvider() {
    _initializeDummyOrders();
  }
  
  void _initializeDummyOrders() {
    _orders = [
      OrderModel(
        id: 'ORD001',
        userId: 'user1',
        items: [
          OrderItem(
            productId: '1',
            productName: 'Premium Wireless Headphones',
            productImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop',
            price: 2999.00,
            quantity: 1,
            selectedColor: 'Black',
          ),
          OrderItem(
            productId: '2',
            productName: 'Cotton Casual T-Shirt',
            productImage: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop',
            price: 599.00,
            quantity: 2,
            selectedSize: 'L',
            selectedColor: 'Navy',
          ),
        ],
        subtotal: 4197.00,
        deliveryFee: 50.00,
        discount: 0.00,
        total: 4247.00,
        deliveryAddress: '123 Main Street, Bangalore, Karnataka 560001',
        paymentMethod: 'Credit Card',
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
        trackingNumber: 'TRK123456789',
      ),
      OrderModel(
        id: 'ORD002',
        userId: 'user1',
        items: [
          OrderItem(
            productId: '3',
            productName: 'Smart Watch Series 5',
            productImage: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop',
            price: 4499.00,
            quantity: 1,
            selectedSize: '42mm',
            selectedColor: 'Black',
          ),
        ],
        subtotal: 4499.00,
        deliveryFee: 50.00,
        discount: 200.00,
        total: 4349.00,
        deliveryAddress: '123 Main Street, Bangalore, Karnataka 560001',
        paymentMethod: 'UPI',
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 15)),
        estimatedDeliveryDate: DateTime.now().subtract(const Duration(days: 12)),
        deliveredDate: DateTime.now().subtract(const Duration(days: 12)),
        trackingNumber: 'TRK987654321',
      ),
      OrderModel(
        id: 'ORD003',
        userId: 'user1',
        items: [
          OrderItem(
            productId: '4',
            productName: 'Running Shoes Pro',
            productImage: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
            price: 3499.00,
            quantity: 1,
            selectedSize: '9',
            selectedColor: 'Blue',
          ),
        ],
        subtotal: 3499.00,
        deliveryFee: 50.00,
        discount: 0.00,
        total: 3549.00,
        deliveryAddress: '123 Main Street, Bangalore, Karnataka 560001',
        paymentMethod: 'Cash on Delivery',
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 5)),
        trackingNumber: 'TRK456789123',
      ),
    ];
  }
  
  List<OrderModel> getRecentOrders({int limit = 3}) {
    return _orders.take(limit).toList();
  }
  
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
  
  void placeOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }
  
  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      // In a real app, you would update the order status through an API
      notifyListeners();
    }
  }
}
