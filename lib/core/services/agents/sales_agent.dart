import 'base_agent.dart';
import 'recommendation_agent.dart';
import 'inventory_agent.dart';
import 'loyalty_agent.dart';
import 'payment_agent.dart';
import 'fulfillment_agent.dart';
import 'support_agent.dart';

/// Main Sales Agent - Orchestrates all worker agents
/// This is the primary interface customers interact with
class SalesAgent extends BaseAgent {
  final RecommendationAgent _recommendationAgent;
  final InventoryAgent _inventoryAgent;
  final LoyaltyAgent _loyaltyAgent;
  final PaymentAgent _paymentAgent;
  final FulfillmentAgent _fulfillmentAgent;
  final SupportAgent _supportAgent;

  // Conversation history for context
  final Map<String, List<ConversationMessage>> _conversations = {};

  SalesAgent({
    required RecommendationAgent recommendationAgent,
    required InventoryAgent inventoryAgent,
    required LoyaltyAgent loyaltyAgent,
    required PaymentAgent paymentAgent,
    required FulfillmentAgent fulfillmentAgent,
    required SupportAgent supportAgent,
  })  : _recommendationAgent = recommendationAgent,
        _inventoryAgent = inventoryAgent,
        _loyaltyAgent = loyaltyAgent,
        _paymentAgent = paymentAgent,
        _fulfillmentAgent = fulfillmentAgent,
        _supportAgent = supportAgent,
        super(
          agentId: 'SALES_AGENT',
          agentName: 'Sales Assistant',
          description: 'Main customer-facing agent that coordinates all services',
        );

  @override
  bool canHandle(AgentRequest request) => true; // Sales agent handles all customer requests

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    // Store conversation context
    _addToConversation(request);

    // Determine intent and route to appropriate handlers
    switch (request.requestType) {
      case 'product_search':
        return await _handleProductSearch(request);
      case 'product_inquiry':
        return await _handleProductInquiry(request);
      case 'check_availability':
        return await _handleAvailabilityCheck(request);
      case 'add_to_cart':
        return await _handleAddToCart(request);
      case 'checkout':
        return await _handleCheckout(request);
      case 'order_status':
        return await _handleOrderStatus(request);
      case 'general_query':
        return await _handleGeneralQuery(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: "I'm not sure how to help with that. Can you rephrase?",
          data: {},
        );
    }
  }

  /// Handle product search requests
  Future<AgentResponse> _handleProductSearch(AgentRequest request) async {
    final query = request.data['query'] as String?;
    final category = request.data['category'] as String?;
    final budget = request.data['budget'] as double?;

    // Coordinate with Recommendation Agent
    final recommendationRequest = AgentRequest(
      requestId: '${request.requestId}_REC',
      customerId: request.customerId,
      requestType: 'get_recommendations',
      data: {
        'query': query,
        'category': category,
        'maxPrice': budget,
      },
    );

    final recommendations = await _recommendationAgent.processRequest(recommendationRequest);

    if (!recommendations.success) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: "Sorry, I couldn't find any products matching your criteria.",
        data: {},
      );
    }

    final products = recommendations.data['products'] as List;

    // Check availability for recommended products
    final availabilityChecks = await Future.wait(
      products.take(5).map((product) async {
        final invRequest = AgentRequest(
          requestId: '${request.requestId}_INV',
          customerId: request.customerId,
          requestType: 'check_stock',
          data: {'productId': product['id']},
        );
        return await _inventoryAgent.processRequest(invRequest);
      }),
    );

    // Build response message
    final responseMessage = _buildProductSearchResponse(products, availabilityChecks);

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: responseMessage,
      data: {
        'products': products,
        'availability': availabilityChecks.map((r) => r.data).toList(),
      },
      suggestedActions: ['View Details', 'Check Store Availability', 'Add to Cart'],
    );
  }

  /// Handle product inquiry with full details
  Future<AgentResponse> _handleProductInquiry(AgentRequest request) async {
    final productId = request.data['productId'] as String;

    // Get product details, availability, and offers
    final futures = await Future.wait([
      _inventoryAgent.processRequest(
        AgentRequest(
          requestId: '${request.requestId}_INV',
          customerId: request.customerId,
          requestType: 'check_stock',
          data: {'productId': productId},
        ),
      ),
      _loyaltyAgent.processRequest(
        AgentRequest(
          requestId: '${request.requestId}_LOY',
          customerId: request.customerId,
          requestType: 'get_applicable_offers',
          data: {'productId': productId},
        ),
      ),
    ]);

    final inventory = futures[0];
    final offers = futures[1];

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: _buildProductInquiryResponse(inventory.data, offers.data),
      data: {
        'inventory': inventory.data,
        'offers': offers.data,
      },
      suggestedActions: ['Add to Cart', 'Reserve for Pickup', 'Buy Now'],
    );
  }

  /// Handle availability check
  Future<AgentResponse> _handleAvailabilityCheck(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final location = request.data['location'] as String?;

    final invResponse = await _inventoryAgent.processRequest(
      AgentRequest(
        requestId: '${request.requestId}_INV',
        customerId: request.customerId,
        requestType: 'check_store_availability',
        data: {
          'productId': productId,
          'location': location,
        },
      ),
    );

    return AgentResponse(
      agentId: agentId,
      success: invResponse.success,
      message: _buildAvailabilityResponse(invResponse.data),
      data: invResponse.data,
      suggestedActions: ['Reserve Now', 'Ship to Home', 'View Other Stores'],
    );
  }

  /// Handle add to cart
  Future<AgentResponse> _handleAddToCart(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final quantity = request.data['quantity'] as int? ?? 1;

    // Check stock first
    final invResponse = await _inventoryAgent.processRequest(
      AgentRequest(
        requestId: '${request.requestId}_INV',
        customerId: request.customerId,
        requestType: 'check_stock',
        data: {'productId': productId, 'quantity': quantity},
      ),
    );

    if (!invResponse.success) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: "Sorry, this item is currently out of stock.",
        data: {},
        suggestedActions: ['Notify When Available', 'View Similar Products'],
      );
    }

    // Get recommendations for complementary products
    final recResponse = await _recommendationAgent.processRequest(
      AgentRequest(
        requestId: '${request.requestId}_REC',
        customerId: request.customerId,
        requestType: 'get_complementary_products',
        data: {'productId': productId},
      ),
    );

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: "Added to cart! ${recResponse.success ? 'You might also like these items.' : ''}",
      data: {
        'cartUpdated': true,
        'complementaryProducts': recResponse.data['products'] ?? [],
      },
      suggestedActions: ['Continue Shopping', 'View Cart', 'Checkout'],
    );
  }

  /// Handle checkout process
  Future<AgentResponse> _handleCheckout(AgentRequest request) async {
    final cartItems = request.data['cartItems'] as List;
    final cartTotal = request.data['total'] as double;

    // Get loyalty benefits
    final loyaltyResponse = await _loyaltyAgent.processRequest(
      AgentRequest(
        requestId: '${request.requestId}_LOY',
        customerId: request.customerId,
        requestType: 'calculate_benefits',
        data: {'cartTotal': cartTotal, 'items': cartItems},
      ),
    );

    final finalTotal = loyaltyResponse.data['finalTotal'] as double;
    final savings = cartTotal - finalTotal;

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: savings > 0
          ? "Great news! You're saving ₹${savings.toStringAsFixed(2)} with your loyalty benefits!"
          : "Your order total is ₹${finalTotal.toStringAsFixed(2)}",
      data: {
        'originalTotal': cartTotal,
        'finalTotal': finalTotal,
        'savings': savings,
        'loyaltyBenefits': loyaltyResponse.data,
      },
      suggestedActions: ['Proceed to Payment', 'Apply Coupon', 'Edit Cart'],
    );
  }

  /// Handle order status queries
  Future<AgentResponse> _handleOrderStatus(AgentRequest request) async {
    final orderId = request.data['orderId'] as String;

    final supportResponse = await _supportAgent.processRequest(
      AgentRequest(
        requestId: '${request.requestId}_SUP',
        customerId: request.customerId,
        requestType: 'track_order',
        data: {'orderId': orderId},
      ),
    );

    return AgentResponse(
      agentId: agentId,
      success: supportResponse.success,
      message: _buildOrderStatusResponse(supportResponse.data),
      data: supportResponse.data,
      suggestedActions: ['Track Delivery', 'Contact Support', 'View Invoice'],
    );
  }

  /// Handle general queries
  Future<AgentResponse> _handleGeneralQuery(AgentRequest request) async {
    final query = request.data['query'] as String;

    // Use conversation history for context
    final conversationHistory = _conversations[request.conversationId] ?? [];

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: _generateContextualResponse(query, conversationHistory),
      data: {'query': query},
      suggestedActions: ['Browse Products', 'View Offers', 'Contact Support'],
    );
  }

  // Helper methods
  void _addToConversation(AgentRequest request) {
    final conversationId = request.conversationId ?? request.customerId;
    _conversations.putIfAbsent(conversationId, () => []);
    _conversations[conversationId]!.add(
      ConversationMessage(
        role: 'user',
        message: request.data['query']?.toString() ?? request.requestType,
        timestamp: request.timestamp,
      ),
    );
  }

  String _buildProductSearchResponse(List products, List availabilityChecks) {
    if (products.isEmpty) {
      return "I couldn't find any products matching your search. Try different keywords?";
    }

    final count = products.length;
    final available = availabilityChecks.where((r) => r.data['inStock'] == true).length;

    return "I found $count products for you! $available are available for immediate purchase. "
        "The top recommendation is ${products[0]['name']} at ₹${products[0]['price']}";
  }

  String _buildProductInquiryResponse(Map inventory, Map offers) {
    final inStock = inventory['inStock'] as bool;
    final hasOffers = (offers['offers'] as List?)?.isNotEmpty ?? false;

    String response = inStock
        ? "Great choice! This product is in stock. "
        : "This item is currently out of stock, but I can notify you when it's available. ";

    if (hasOffers) {
      final discount = offers['offers'][0]['discount'];
      response += "Plus, there's a $discount% discount available right now!";
    }

    return response;
  }

  String _buildAvailabilityResponse(Map data) {
    final onlineStock = data['onlineStock'] as int? ?? 0;
    final stores = data['stores'] as List? ?? [];

    if (onlineStock > 0 && stores.isNotEmpty) {
      return "Available online (ships in 2-3 days) and at ${stores.length} nearby stores for immediate pickup!";
    } else if (onlineStock > 0) {
      return "Available online! We can ship it to you in 2-3 days.";
    } else if (stores.isNotEmpty) {
      return "Available at ${stores[0]['name']}, just ${stores[0]['distance']}km away!";
    } else {
      return "Currently out of stock. Would you like me to notify you when it's back?";
    }
  }

  String _buildOrderStatusResponse(Map data) {
    final status = data['status'] as String;
    final trackingNumber = data['trackingNumber'] as String?;

    switch (status.toLowerCase()) {
      case 'shipped':
        return "Your order is on the way! Tracking number: $trackingNumber. Expected delivery in 2-3 days.";
      case 'delivered':
        return "Your order was delivered! Hope you love it! Need any help or want to return something?";
      case 'processing':
        return "Your order is being prepared for shipment. We'll update you once it ships!";
      default:
        return "Your order status: $status. Need more details?";
    }
  }

  String _generateContextualResponse(String query, List<ConversationMessage> history) {
    // Simple rule-based responses (in production, use LLM here)
    if (query.toLowerCase().contains('help')) {
      return "I'm here to help! You can ask me about products, check order status, or get personalized recommendations.";
    }
    return "I understand you're asking about: $query. Let me help you with that!";
  }
}

/// Conversation message for context
class ConversationMessage {
  final String role; // 'user' or 'agent'
  final String message;
  final DateTime timestamp;

  ConversationMessage({
    required this.role,
    required this.message,
    required this.timestamp,
  });
}
