import 'base_agent.dart';
import '../../utils/order_provider.dart';

/// Support Agent - Handles post-purchase support
class SupportAgent extends BaseAgent {
  final OrderProvider? _orderProvider;

  SupportAgent({OrderProvider? orderProvider})
      : _orderProvider = orderProvider,
        super(
          agentId: 'SUPPORT_AGENT',
          agentName: 'Customer Support Specialist',
          description: 'Handles order tracking, returns, and customer feedback',
        );

  @override
  bool canHandle(AgentRequest request) {
    return [
      'track_order',
      'initiate_return',
      'collect_feedback',
      'suggest_related_products'
    ].contains(request.requestType);
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    switch (request.requestType) {
      case 'track_order':
        return await _trackOrder(request);
      case 'initiate_return':
        return await _initiateReturn(request);
      case 'collect_feedback':
        return await _collectFeedback(request);
      case 'suggest_related_products':
        return await _suggestRelatedProducts(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Unknown request type',
          data: {},
        );
    }
  }

  Future<AgentResponse> _trackOrder(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;

    // Get order from provider if available
    final order = _orderProvider?.getOrderById(orderId);

    if (order == null) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: 'Order not found',
        data: {},
      );
    }

    // Get tracking details
    final trackingDetails = {
      'orderId': orderId,
      'status': order.status.name,
      'trackingNumber': order.trackingNumber,
      'orderDate': order.orderDate.toIso8601String(),
      'estimatedDelivery': order.estimatedDeliveryDate?.toIso8601String(),
      'deliveredDate': order.deliveredDate?.toIso8601String(),
      'currentLocation': _getCurrentLocation(order.status.name),
      'timeline': _getOrderTimeline(order),
    };

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: _getStatusMessage(order.status.name),
      data: trackingDetails,
    );
  }

  Future<AgentResponse> _initiateReturn(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;
    final reason = request.data['reason'] as String;
    final items = request.data['items'] as List<String>?;

    final returnId = 'RET${DateTime.now().millisecondsSinceEpoch}';

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Return request submitted. We\'ll process it within 24 hours.',
      data: {
        'returnId': returnId,
        'orderId': orderId,
        'reason': reason,
        'items': items,
        'status': 'INITIATED',
        'pickupScheduled': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'refundETA': '7-10 business days',
      },
    );
  }

  Future<AgentResponse> _collectFeedback(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;
    final rating = request.data['rating'] as int?;
    final comment = request.data['comment'] as String?;

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Thank you for your feedback! It helps us improve.',
      data: {
        'orderId': orderId,
        'rating': rating,
        'comment': comment,
        'feedbackId': 'FB${DateTime.now().millisecondsSinceEpoch}',
      },
    );
  }

  Future<AgentResponse> _suggestRelatedProducts(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;

    // Get order details
    final order = _orderProvider?.getOrderById(orderId);

    if (order == null) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: 'Order not found',
        data: {},
      );
    }

    // Suggest complementary products based on order items
    final suggestions = [
      {
        'id': 'PROD_ACC1',
        'name': 'Product Care Kit',
        'price': 299.0,
        'reason': 'Keep your purchase in perfect condition',
      },
      {
        'id': 'PROD_ACC2',
        'name': 'Extended Warranty',
        'price': 499.0,
        'reason': 'Protect your investment',
      },
    ];

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'You might also like these products!',
      data: {
        'suggestions': suggestions,
        'discount': '15% off for recent customers',
      },
    );
  }

  String _getCurrentLocation(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Order received at warehouse';
      case 'processing':
        return 'Being packed at fulfillment center';
      case 'shipped':
        return 'In transit to delivery hub';
      case 'out_for_delivery':
      case 'outfordelivery':
        return 'Out for delivery - Delivery partner assigned';
      case 'delivered':
        return 'Delivered successfully';
      default:
        return 'Processing';
    }
  }

  List<Map<String, dynamic>> _getOrderTimeline(order) {
    return [
      {
        'status': 'Order Placed',
        'date': order.orderDate.toIso8601String(),
        'completed': true,
      },
      {
        'status': 'Processing',
        'date': order.orderDate.add(const Duration(hours: 6)).toIso8601String(),
        'completed': ['processing', 'shipped', 'delivered'].contains(order.status.name.toLowerCase()),
      },
      {
        'status': 'Shipped',
        'date': order.orderDate.add(const Duration(days: 1)).toIso8601String(),
        'completed': ['shipped', 'delivered'].contains(order.status.name.toLowerCase()),
      },
      {
        'status': 'Out for Delivery',
        'date': order.estimatedDeliveryDate?.toIso8601String(),
        'completed': ['delivered'].contains(order.status.name.toLowerCase()),
      },
      {
        'status': 'Delivered',
        'date': order.deliveredDate?.toIso8601String() ?? order.estimatedDeliveryDate?.toIso8601String(),
        'completed': order.status.name.toLowerCase() == 'delivered',
      },
    ];
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Your order has been received and is being processed.';
      case 'processing':
        return 'Your order is being prepared for shipment.';
      case 'shipped':
        return 'Your order is on the way!';
      case 'out_for_delivery':
      case 'outfordelivery':
        return 'Your order is out for delivery. Expect it today!';
      case 'delivered':
        return 'Your order has been delivered. Enjoy your purchase!';
      case 'cancelled':
        return 'Your order has been cancelled.';
      case 'returned':
        return 'Your return has been processed.';
      default:
        return 'Order status: $status';
    }
  }
}
