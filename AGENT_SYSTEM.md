# ShopSync Multi-Agent AI System

## Overview
This is a complete implementation of an omnichannel AI shopping assistant that provides seamless customer experience across all channels (mobile app, physical store, WhatsApp, etc.).

## Architecture

### 🎯 Sales Agent (Main Orchestrator)
The primary customer-facing agent that coordinates all other agents.
- **File**: `sales_agent.dart`
- **Role**: Waiter/Conductor - talks to customer and coordinates specialists
- **Handles**: All customer requests and routes to appropriate worker agents

### 👷 Worker Agents (Specialists)

#### 1. 📦 Recommendation Agent
- **File**: `recommendation_agent.dart`  
- **Purpose**: Suggests personalized products
- **Capabilities**:
  - Product search and recommendations
  - Complementary product suggestions
  - Similar product finder
  - Rating-based sorting

#### 2. 📊 Inventory Agent
- **File**: `inventory_agent.dart`
- **Purpose**: Stock management and availability
- **Capabilities**:
  - Check online warehouse stock
  - Check physical store availability
  - Reserve items for pickup/trial
  - Cross-channel inventory visibility

#### 3. 🎁 Loyalty & Offers Agent
- **File**: `loyalty_agent.dart`
- **Purpose**: Discounts and loyalty benefits
- **Capabilities**:
  - Apply loyalty points
  - Calculate tier-based discounts
  - Validate and apply coupons
  - Bundle discounts
  - Find best offers

#### 4. 💳 Payment Agent
- **File**: `payment_agent.dart`
- **Purpose**: Payment processing
- **Capabilities**:
  - Process payments (Card, UPI, Wallet, COD)
  - Handle payment failures gracefully
  - Suggest alternative payment methods
  - Process refunds

#### 5. 🚚 Fulfillment Agent
- **File**: `fulfillment_agent.dart`
- **Purpose**: Delivery and pickup coordination
- **Capabilities**:
  - Schedule home delivery
  - Arrange store pickup
  - Reserve for in-store trial
  - Provide delivery options

#### 6. 🛟 Support Agent
- **File**: `support_agent.dart`
- **Purpose**: Post-purchase support
- **Capabilities**:
  - Track orders
  - Initiate returns/exchanges
  - Collect feedback
  - Suggest related products (smart upselling)

## How to Use

### 1. Initialize AgentManager

```dart
// In your main.dart or app initialization
final agentManager = AgentManager(
  productProvider: productProvider,
  orderProvider: orderProvider,
);
```

### 2. Use in Your App

#### Example: Product Search
```dart
final response = await agentManager.searchProducts(
  customerId: 'user123',
  query: 'running shoes',
  category: 'Sports & Outdoors',
  maxPrice: 5000,
);

if (response.success) {
  final products = response.data['products'];
  final availability = response.data['availability'];
  print(response.message); // "I found 5 products for you!..."
}
```

#### Example: Check Product Availability
```dart
final response = await agentManager.checkAvailability(
  customerId: 'user123',
  productId: 'PROD001',
  location: 'Mumbai',
);

print(response.message); 
// "Available at Phoenix Mall Mumbai, just 2.5km away!"
```

#### Example: Checkout with Loyalty Benefits
```dart
final response = await agentManager.processCheckout(
  customerId: 'user123',
  cartItems: cartItems,
  total: 5000.0,
);

// Response includes:
// - Original total
// - Loyalty points discount
// - Tier-based discount
// - Final total
// - Savings amount
```

#### Example: Track Order
```dart
final response = await agentManager.trackOrder(
  customerId: 'user123',
  orderId: 'ORD001',
);

print(response.message);
// "Your order is on the way! Tracking: TRK123..."
```

### 3. Advanced Usage: Direct Request

```dart
final response = await agentManager.sendRequest(
  customerId: 'user123',
  requestType: 'product_inquiry',
  data: {'productId': 'PROD001'},
  channel: 'app', // 'store', 'whatsapp', etc.
);
```

## Omnichannel Features

### Channel Handoff
The system maintains conversation history across all channels:

```dart
// Monday 9 AM - Mobile App
await agentManager.searchProducts(
  customerId: 'sarah',
  query: 'nike shoes',
);

// Monday 6 PM - In-Store Kiosk
final history = agentManager.getConversationHistory('sarah');
// Returns: Previous search context from mobile app!

// Agent knows Sarah was looking at Nike shoes
// Can continue the conversation seamlessly
```

### Customer Context Retention
```dart
// Get last interaction for personalized greeting
final lastInteraction = agentManager.getLastInteraction('sarah');
// Use this to show: "Welcome back! Still interested in Nike Pegasus 40?"
```

## Request Types

### Sales Agent (Customer-Facing)
- `product_search` - Search for products
- `product_inquiry` - Get detailed product info
- `check_availability` - Check stock across channels
- `add_to_cart` - Add items with smart suggestions
- `checkout` - Process checkout with offers
- `order_status` - Track orders
- `general_query` - Handle general questions

### Worker Agents (Backend)
Each worker agent has specific request types (see individual agent files).

## Response Structure

All agents return `AgentResponse`:
```dart
class AgentResponse {
  final String agentId;        // Which agent responded
  final bool success;          // Success status
  final String message;        // Human-readable message
  final Map<String, dynamic> data;  // Structured data
  final List<String>? suggestedActions;  // Next steps
  final DateTime timestamp;    // Response time
}
```

## Integration Points

### 1. Add to Provider (main.dart)
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => OrderProvider()),
    ChangeNotifierProvider(
      create: (context) => AgentManager(
        productProvider: context.read<ProductProvider>(),
        orderProvider: context.read<OrderProvider>(),
      ),
    ),
  ],
  child: MyApp(),
)
```

### 2. Use in Screens
```dart
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final agentManager = Provider.of<AgentManager>(context);
    
    return FutureBuilder<AgentResponse>(
      future: agentManager.searchProducts(
        customerId: 'user123',
        query: searchQuery,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final response = snapshot.data!;
          return ProductListView(
            products: response.data['products'],
            message: response.message,
          );
        }
        return LoadingIndicator();
      },
    );
  }
}
```

## Real-World Example: Complete Shopping Journey

```dart
// 1. Search for products
final searchResponse = await agentManager.searchProducts(
  customerId: 'sarah',
  query: 'running shoes for marathon',
  maxPrice: 10000,
);
// Sales Agent → Recommendation Agent → Inventory Agent → Loyalty Agent
// Result: "I found 3 products with 20% off!"

// 2. Check specific product
final productResponse = await agentManager.sendRequest(
  customerId: 'sarah',
  requestType: 'product_inquiry',
  data: {'productId': 'NIKE_001'},
);
// Sales Agent → Inventory Agent + Loyalty Agent
// Result: "In stock at Phoenix Mall + 20% discount!"

// 3. Add to cart
final cartResponse = await agentManager.sendRequest(
  customerId: 'sarah',
  requestType: 'add_to_cart',
  data: {'productId': 'NIKE_001', 'quantity': 1},
);
// Sales Agent → Inventory Agent → Recommendation Agent
// Result: "Added! You might also like these socks..."

// 4. Checkout
final checkoutResponse = await agentManager.processCheckout(
  customerId: 'sarah',
  cartItems: cart,
  total: 8995,
);
// Sales Agent → Loyalty Agent
// Result: "You're saving ₹1,799 with loyalty benefits!"

// 5. Next day - Track order
final trackResponse = await agentManager.trackOrder(
  customerId: 'sarah',
  orderId: 'ORD001',
);
// Sales Agent → Support Agent
// Result: "Your order is out for delivery!"
```

## Next Steps

### Phase 1: Basic Integration ✅ (Done)
- Multi-agent architecture created
- All agents implemented
- AgentManager orchestrator ready

### Phase 2: UI Integration (To Do)
1. Create AI Chat Widget
2. Add to product detail screens
3. Integrate with search
4. Add to checkout flow

### Phase 3: Advanced Features (Future)
1. Connect to actual LLM (GPT-4, Claude)
2. WhatsApp integration
3. Voice assistant
4. QR code scanning in stores
5. Real-time inventory sync
6. Push notifications for offers

## Benefits

✅ **Omnichannel Experience**: Seamless handoff between app, store, WhatsApp  
✅ **Context Retention**: Remembers customer preferences across channels  
✅ **Smart Recommendations**: Personalized suggestions based on behavior  
✅ **Proactive Support**: Follow-up after purchase with relevant offers  
✅ **Efficient Operations**: Agents work in parallel, not sequential  
✅ **Scalable Architecture**: Easy to add new agents or capabilities  

## File Structure
```
lib/core/services/agents/
├── base_agent.dart              # Base classes
├── agent_manager.dart           # Main orchestrator
├── sales_agent.dart             # Customer-facing agent
├── recommendation_agent.dart    # Product suggestions
├── inventory_agent.dart         # Stock management
├── loyalty_agent.dart           # Discounts & loyalty
├── payment_agent.dart           # Payment processing
├── fulfillment_agent.dart       # Delivery coordination
└── support_agent.dart           # Post-purchase support
```

---

**Ready to revolutionize your shopping experience! 🚀**
