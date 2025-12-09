import 'package:flutter/foundation.dart';
import 'base_agent.dart';
import 'sales_agent.dart';
import 'recommendation_agent.dart';
import 'inventory_agent.dart';
import 'loyalty_agent.dart';
import 'payment_agent.dart';
import 'fulfillment_agent.dart';
import 'support_agent.dart';
import '../../utils/product_provider.dart';
import '../../utils/order_provider.dart';

/// Agent Manager - Central orchestrator for all agents
/// This is the single entry point for interacting with the multi-agent system
class AgentManager extends ChangeNotifier {
  late final SalesAgent _salesAgent;
  late final RecommendationAgent _recommendationAgent;
  late final InventoryAgent _inventoryAgent;
  late final LoyaltyAgent _loyaltyAgent;
  late final PaymentAgent _paymentAgent;
  late final FulfillmentAgent _fulfillmentAgent;
  late final SupportAgent _supportAgent;

  // Conversation history for omnichannel experience
  final Map<String, List<ConversationEntry>> _conversationHistory = {};

  AgentManager({
    required ProductProvider productProvider,
    required OrderProvider orderProvider,
  }) {
    // Initialize all worker agents
    _recommendationAgent = RecommendationAgent(productProvider: productProvider);
    _inventoryAgent = InventoryAgent();
    _loyaltyAgent = LoyaltyAgent();
    _paymentAgent = PaymentAgent();
    _fulfillmentAgent = FulfillmentAgent();
    _supportAgent = SupportAgent(orderProvider: orderProvider);

    // Initialize sales agent with all workers
    _salesAgent = SalesAgent(
      recommendationAgent: _recommendationAgent,
      inventoryAgent: _inventoryAgent,
      loyaltyAgent: _loyaltyAgent,
      paymentAgent: _paymentAgent,
      fulfillmentAgent: _fulfillmentAgent,
      supportAgent: _supportAgent,
    );

    debugPrint('✅ AgentManager initialized with multi-agent system');
  }

  /// Main entry point - Send a request to the AI assistant
  /// This handles all customer interactions
  Future<AgentResponse> sendRequest({
    required String customerId,
    required String requestType,
    required Map<String, dynamic> data,
    String? conversationId,
    String? channel, // 'app', 'store', 'whatsapp', etc.
  }) async {
    final request = AgentRequest(
      requestId: _generateRequestId(),
      customerId: customerId,
      requestType: requestType,
      data: data,
      conversationId: conversationId ?? customerId,
    );

    // Log conversation for omnichannel tracking
    _logConversation(
      customerId: customerId,
      conversationId: conversationId ?? customerId,
      channel: channel ?? 'app',
      request: request,
    );

    // Process through sales agent
    final response = await _salesAgent.processRequest(request);

    // Log response
    _logConversation(
      customerId: customerId,
      conversationId: conversationId ?? customerId,
      channel: channel ?? 'app',
      response: response,
    );

    notifyListeners();
    return response;
  }

  /// Get conversation history for a customer
  /// This enables seamless handoff between channels
  List<ConversationEntry> getConversationHistory(String customerId) {
    return _conversationHistory[customerId] ?? [];
  }

  /// Clear conversation history
  void clearConversationHistory(String customerId) {
    _conversationHistory.remove(customerId);
    notifyListeners();
  }

  /// Get last interaction details (for channel handoff)
  ConversationEntry? getLastInteraction(String customerId) {
    final history = _conversationHistory[customerId];
    if (history == null || history.isEmpty) return null;
    return history.last;
  }

  /// Direct access to specific agents (for advanced use cases)
  RecommendationAgent get recommendationAgent => _recommendationAgent;
  InventoryAgent get inventoryAgent => _inventoryAgent;
  LoyaltyAgent get loyaltyAgent => _loyaltyAgent;
  PaymentAgent get paymentAgent => _paymentAgent;
  FulfillmentAgent get fulfillmentAgent => _fulfillmentAgent;
  SupportAgent get supportAgent => _supportAgent;

  // Helper methods
  void _logConversation({
    required String customerId,
    required String conversationId,
    required String channel,
    AgentRequest? request,
    AgentResponse? response,
  }) {
    _conversationHistory.putIfAbsent(customerId, () => []);
    
    if (request != null) {
      _conversationHistory[customerId]!.add(
        ConversationEntry(
          type: ConversationEntryType.request,
          channel: channel,
          timestamp: DateTime.now(),
          data: request.toJson(),
        ),
      );
    }
    
    if (response != null) {
      _conversationHistory[customerId]!.add(
        ConversationEntry(
          type: ConversationEntryType.response,
          channel: channel,
          timestamp: DateTime.now(),
          data: response.toJson(),
        ),
      );
    }

    // Keep only last 50 entries per customer
    if (_conversationHistory[customerId]!.length > 50) {
      _conversationHistory[customerId]!.removeRange(0, 10);
    }
  }

  String _generateRequestId() {
    return 'REQ_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Example helper methods for common actions
  
  Future<AgentResponse> searchProducts({
    required String customerId,
    required String query,
    String? category,
    double? maxPrice,
  }) {
    return sendRequest(
      customerId: customerId,
      requestType: 'product_search',
      data: {
        'query': query,
        'category': category,
        'budget': maxPrice,
      },
    );
  }

  Future<AgentResponse> checkAvailability({
    required String customerId,
    required String productId,
    String? location,
  }) {
    return sendRequest(
      customerId: customerId,
      requestType: 'check_availability',
      data: {
        'productId': productId,
        'location': location,
      },
    );
  }

  Future<AgentResponse> processCheckout({
    required String customerId,
    required List<Map<String, dynamic>> cartItems,
    required double total,
  }) {
    return sendRequest(
      customerId: customerId,
      requestType: 'checkout',
      data: {
        'cartItems': cartItems,
        'total': total,
      },
    );
  }

  Future<AgentResponse> trackOrder({
    required String customerId,
    required String orderId,
  }) {
    return sendRequest(
      customerId: customerId,
      requestType: 'order_status',
      data: {
        'orderId': orderId,
      },
    );
  }
}

/// Conversation entry for tracking omnichannel interactions
class ConversationEntry {
  final ConversationEntryType type;
  final String channel;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  ConversationEntry({
    required this.type,
    required this.channel,
    required this.timestamp,
    required this.data,
  });
}

enum ConversationEntryType {
  request,
  response,
}
