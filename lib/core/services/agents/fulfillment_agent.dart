import 'base_agent.dart';

/// Fulfillment Agent - Manages order delivery and pickup
class FulfillmentAgent extends BaseAgent {
  FulfillmentAgent()
      : super(
          agentId: 'FULFILLMENT_AGENT',
          agentName: 'Order Fulfillment Manager',
          description: 'Manages delivery, pickup, and order scheduling',
        );

  @override
  bool canHandle(AgentRequest request) {
    return [
      'schedule_delivery',
      'arrange_pickup',
      'reserve_for_trial',
      'get_delivery_options'
    ].contains(request.requestType);
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    switch (request.requestType) {
      case 'schedule_delivery':
        return await _scheduleDelivery(request);
      case 'arrange_pickup':
        return await _arrangePickup(request);
      case 'reserve_for_trial':
        return await _reserveForTrial(request);
      case 'get_delivery_options':
        return await _getDeliveryOptions(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Unknown request type',
          data: {},
        );
    }
  }

  Future<AgentResponse> _scheduleDelivery(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;
    final address = request.data['address'] as String;
    final deliveryType = request.data['deliveryType'] as String? ?? 'standard';

    int estimatedDays;
    switch (deliveryType) {
      case 'express':
        estimatedDays = 1;
        break;
      case 'same_day':
        estimatedDays = 0;
        break;
      default:
        estimatedDays = 3;
    }

    final deliveryDate = DateTime.now().add(Duration(days: estimatedDays));
    final trackingNumber = 'TRK${DateTime.now().millisecondsSinceEpoch}';

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Delivery scheduled successfully!',
      data: {
        'orderId': orderId,
        'trackingNumber': trackingNumber,
        'estimatedDeliveryDate': deliveryDate.toIso8601String(),
        'deliveryDays': estimatedDays,
        'deliveryType': deliveryType,
        'address': address,
      },
    );
  }

  Future<AgentResponse> _arrangePickup(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;
    final storeId = request.data['storeId'] as String;

    final pickupCode = 'PU${DateTime.now().millisecondsSinceEpoch % 10000}';
    final readyTime = DateTime.now().add(const Duration(hours: 2));

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Order ready for pickup in 2 hours!',
      data: {
        'orderId': orderId,
        'storeId': storeId,
        'pickupCode': pickupCode,
        'readyTime': readyTime.toIso8601String(),
        'counterNumber': '3',
        'validUntil': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      },
    );
  }

  Future<AgentResponse> _reserveForTrial(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final storeId = request.data['storeId'] as String;
    final customerId = request.customerId;

    final reservationCode = 'TRIAL${DateTime.now().millisecondsSinceEpoch % 10000}';

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Product reserved for trial. Visit within 24 hours!',
      data: {
        'reservationCode': reservationCode,
        'productId': productId,
        'storeId': storeId,
        'customerId': customerId,
        'validUntil': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        'counterNumber': '5',
      },
    );
  }

  Future<AgentResponse> _getDeliveryOptions(AgentRequest request) async {
    final cartTotal = request.data['cartTotal'] as double;
    final location = request.data['location'] as String?;

    final options = [
      {
        'type': 'standard',
        'name': 'Standard Delivery',
        'days': 3,
        'cost': cartTotal >= 500 ? 0.0 : 50.0,
        'description': 'Free shipping on orders above ₹500',
      },
      {
        'type': 'express',
        'name': 'Express Delivery',
        'days': 1,
        'cost': 100.0,
        'description': 'Get it by tomorrow',
      },
      {
        'type': 'pickup',
        'name': 'Store Pickup',
        'hours': 2,
        'cost': 0.0,
        'description': 'Pick up from nearest store in 2 hours',
      },
    ];

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Here are your delivery options',
      data: {
        'options': options,
        'recommendedOption': cartTotal >= 500 ? 'standard' : 'pickup',
      },
    );
  }
}
