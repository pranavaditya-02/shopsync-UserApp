import 'package:flutter/material.dart';
import '../../app/localization/app_localizations.dart';
import '../../core/utils/helpers.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final notifications = [
      {
        'title': 'Order Shipped',
        'message': 'Your order #ORD001 has been shipped',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'icon': Icons.local_shipping,
        'color': Colors.blue,
      },
      {
        'title': 'New Offer Available',
        'message': 'Get 50% off on electronics',
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'icon': Icons.local_offer,
        'color': Colors.orange,
      },
      {
        'title': 'Order Delivered',
        'message': 'Your order #ORD002 has been delivered',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'Price Drop Alert',
        'message': 'Items in your wishlist are now on sale',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'icon': Icons.trending_down,
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notifications),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (notification['color'] as Color).withOpacity(0.1),
                child: Icon(
                  notification['icon'] as IconData,
                  color: notification['color'] as Color,
                ),
              ),
              title: Text(notification['title'] as String),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification['message'] as String),
                  const SizedBox(height: 4),
                  Text(
                    Helpers.formatDateTime(notification['time'] as DateTime),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
