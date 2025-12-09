import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../app/localization/app_localizations.dart';
import '../../core/utils/cart_provider.dart';
import '../../core/utils/order_provider.dart';
import '../../core/utils/helpers.dart';
import '../../models/order_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  String _deliveryAddress = '123 Main Street, Bangalore, Karnataka 560001';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.checkout),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address
            Text(
              localizations.deliveryAddress,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(_deliveryAddress),
                trailing: TextButton(
                  onPressed: () {
                    // Change address
                  },
                  child: const Text('Change'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method
            Text(
              localizations.paymentMethod,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...[
              'Credit Card',
              'Debit Card',
              'UPI',
              'Cash on Delivery',
            ].map((method) {
              return Card(
                child: RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 24),

            // Order Summary
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.subtotal),
                        Text(Helpers.formatCurrency(cartProvider.subtotal)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee'),
                        Text(Helpers.formatCurrency(cartProvider.deliveryFee)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.total,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Helpers.formatCurrency(cartProvider.total),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _placeOrder(context, cartProvider, orderProvider, localizations);
            },
            child: Text(localizations.placeOrder),
          ),
        ),
      ),
    );
  }

  void _placeOrder(
    BuildContext context,
    CartProvider cartProvider,
    OrderProvider orderProvider,
    AppLocalizations localizations,
  ) {
    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user1',
      items: cartProvider.items.map((item) {
        return OrderItem(
          productId: item.productId,
          productName: item.productName,
          productImage: item.productImage,
          price: item.price,
          quantity: item.quantity,
          selectedSize: item.selectedSize,
          selectedColor: item.selectedColor,
        );
      }).toList(),
      subtotal: cartProvider.subtotal,
      deliveryFee: cartProvider.deliveryFee,
      discount: 0,
      total: cartProvider.total,
      deliveryAddress: _deliveryAddress,
      paymentMethod: _selectedPaymentMethod,
      status: OrderStatus.pending,
      orderDate: DateTime.now(),
      estimatedDeliveryDate: DateTime.now().add(const Duration(days: 5)),
    );

    orderProvider.placeOrder(order);
    cartProvider.clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
          title: Text(localizations.orderPlaced),
          content: Text('Order ID: ${order.id}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/orders');
              },
              child: Text(localizations.myOrders),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/home');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }
}
