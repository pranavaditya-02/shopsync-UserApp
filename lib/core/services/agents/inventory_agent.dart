import 'base_agent.dart';

/// Inventory Agent - Manages stock and availability
class InventoryAgent extends BaseAgent {
  // In production, this would connect to real inventory system
  final Map<String, int> _onlineStock = {
    '1': 50,
    '2': 30,
    '3': 45,
    '4': 25,
    '5': 60,
    '6': 40,
    '7': 35,
    '8': 20,
  };

  final List<Store> _stores = [
    Store(id: 'ST001', name: 'Phoenix Mall Mumbai', distance: 2.5, location: 'Mumbai'),
    Store(id: 'ST002', name: 'Select City Walk Delhi', distance: 5.0, location: 'Delhi'),
    Store(id: 'ST003', name: 'Inorbit Mall Bangalore', distance: 3.2, location: 'Bangalore'),
  ];

  InventoryAgent()
      : super(
          agentId: 'INVENTORY_AGENT',
          agentName: 'Inventory Manager',
          description: 'Manages stock levels and availability across channels',
        );

  @override
  bool canHandle(AgentRequest request) {
    return ['check_stock', 'check_store_availability', 'reserve_item'].contains(request.requestType);
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    switch (request.requestType) {
      case 'check_stock':
        return await _checkStock(request);
      case 'check_store_availability':
        return await _checkStoreAvailability(request);
      case 'reserve_item':
        return await _reserveItem(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Unknown request type',
          data: {},
        );
    }
  }

  Future<AgentResponse> _checkStock(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final quantity = request.data['quantity'] as int? ?? 1;

    final stock = _onlineStock[productId] ?? 0;
    final inStock = stock >= quantity;

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: inStock ? 'Product is in stock' : 'Product is out of stock',
      data: {
        'productId': productId,
        'inStock': inStock,
        'availableQuantity': stock,
        'requestedQuantity': quantity,
      },
    );
  }

  Future<AgentResponse> _checkStoreAvailability(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final location = request.data['location'] as String? ?? 'Mumbai';

    // Simulate store stock check
    final nearbyStores = _stores
        .where((store) => store.location.toLowerCase().contains(location.toLowerCase()))
        .map((store) => {
              'storeId': store.id,
              'name': store.name,
              'distance': store.distance,
              'inStock': true, // Simulated
              'quantity': 5,
            })
        .toList();

    final onlineStock = _onlineStock[productId] ?? 0;

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Checked availability across all channels',
      data: {
        'productId': productId,
        'onlineStock': onlineStock,
        'stores': nearbyStores,
        'shippingDays': 2,
      },
    );
  }

  Future<AgentResponse> _reserveItem(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final storeId = request.data['storeId'] as String;
    final quantity = request.data['quantity'] as int? ?? 1;

    // Simulate reservation
    final reservationCode = 'RES${DateTime.now().millisecondsSinceEpoch}';

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Item reserved successfully',
      data: {
        'reservationCode': reservationCode,
        'productId': productId,
        'storeId': storeId,
        'quantity': quantity,
        'validUntil': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
      },
    );
  }
}

class Store {
  final String id;
  final String name;
  final double distance;
  final String location;

  Store({
    required this.id,
    required this.name,
    required this.distance,
    required this.location,
  });
}
