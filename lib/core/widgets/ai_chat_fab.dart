import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/product_provider.dart';

class AIChatFAB extends StatefulWidget {
  const AIChatFAB({super.key});

  @override
  State<AIChatFAB> createState() => _AIChatFABState();
}

class _AIChatFABState extends State<AIChatFAB> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showChatBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, scrollController) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Shopping Agent',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'How can I help you today?',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  
                  // Chat messages area
                  Expanded(
                    child: _messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.chat_bubble_outline,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Start a conversation',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    'Ask me about products, availability, recommendations, orders, or anything else!',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return _buildChatMessage(message);
                            },
                          ),
                  ),
                  
                  // Loading indicator
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'AI is thinking...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Input area
                  Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(setModalState),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _isLoading ? null : () => _sendMessage(setModalState),
                          icon: const Icon(Icons.send),
                          style: IconButton.styleFrom(
                            backgroundColor: _isLoading 
                                ? Colors.grey[300]
                                : Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(StateSetter setModalState) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    setModalState(() {});

    _messageController.clear();

    // Get AI response (mock)
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    
    String aiResponse = _generateMockResponse(message.toLowerCase());

    setState(() {
      _messages.add(ChatMessage(
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isLoading = false;
    });
    setModalState(() {});
  }

  String _generateMockResponse(String query) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final allProducts = productProvider.products;
    
    // Specific product search (shoes, headphones, watch, etc.)
    if (query.contains('shoe') || query.contains('sneaker') || query.contains('athletic') || query.contains('running')) {
      final shoes = allProducts.where((p) => 
        p.name.toLowerCase().contains('shoe') || 
        p.category.toLowerCase().contains('sports') ||
        p.description.toLowerCase().contains('running')
      ).toList();
      
      if (shoes.isNotEmpty) {
        final shoe = shoes.first;
        final discount = shoe.originalPrice != null 
            ? ((shoe.originalPrice! - shoe.price) / shoe.originalPrice! * 100).round()
            : 0;
        final priceText = shoe.originalPrice != null
            ? "💰 Price: ₹${shoe.price.toStringAsFixed(0)} (${discount}% OFF)\nOriginal Price: ₹${shoe.originalPrice!.toStringAsFixed(0)}\n\n"
            : "💰 Price: ₹${shoe.price.toStringAsFixed(0)}\n\n";
        return "🏃 I found the perfect athletic shoes for you!\n\n" +
               "📦 ${shoe.name}\n" +
               "${shoe.description}\n\n" +
               priceText +
               "📍 Nearest Store: ${shoe.storeLocation}\n" +
               "📊 Stock: ${shoe.availableQuantity} units available\n" +
               "⭐ Rating: ${shoe.rating}/5 (${shoe.reviewCount} reviews)\n\n" +
               "Available sizes: ${shoe.sizes.isEmpty ? 'Standard' : shoe.sizes.join(', ')}\n" +
               "Available colors: ${shoe.colors.join(', ')}\n\n" +
               "Would you like to add this to your cart?";
      }
    }
    
    if (query.contains('headphone') || query.contains('earphone') || query.contains('audio')) {
      final audio = allProducts.where((p) => 
        p.name.toLowerCase().contains('headphone') || 
        p.name.toLowerCase().contains('earphone') ||
        p.category.toLowerCase().contains('electronics')
      ).toList();
      
      if (audio.isNotEmpty) {
        final product = audio.first;
        final discount = product.originalPrice != null 
            ? ((product.originalPrice! - product.price) / product.originalPrice! * 100).round()
            : 0;
        final priceText = product.originalPrice != null
            ? "💰 Price: ₹${product.price.toStringAsFixed(0)} (${discount}% OFF)\nOriginal Price: ₹${product.originalPrice!.toStringAsFixed(0)}\n\n"
            : "💰 Price: ₹${product.price.toStringAsFixed(0)}\n\n";
        return "🎧 Check out this amazing audio product!\n\n" +
               "📦 ${product.name}\n" +
               "${product.description}\n\n" +
               priceText +
               "📍 Nearest Store: ${product.storeLocation}\n" +
               "📊 Stock: ${product.availableQuantity} units available\n" +
               "⭐ Rating: ${product.rating}/5 (${product.reviewCount} reviews)\n\n" +
               "Available colors: ${product.colors.join(', ')}\n\n" +
               "Great for music lovers! Interested?";
      }
    }
    
    if (query.contains('watch') || query.contains('smartwatch')) {
      final watches = allProducts.where((p) => 
        p.name.toLowerCase().contains('watch')
      ).toList();
      
      if (watches.isNotEmpty) {
        final product = watches.first;
        final discount = product.originalPrice != null 
            ? ((product.originalPrice! - product.price) / product.originalPrice! * 100).round()
            : 0;
        final priceText = product.originalPrice != null
            ? "💰 Price: ₹${product.price.toStringAsFixed(0)} (${discount}% OFF)\nOriginal Price: ₹${product.originalPrice!.toStringAsFixed(0)}\n\n"
            : "💰 Price: ₹${product.price.toStringAsFixed(0)}\n\n";
        return "⌚ Here's an excellent smartwatch option!\n\n" +
               "📦 ${product.name}\n" +
               "${product.description}\n\n" +
               priceText +
               "📍 Nearest Store: ${product.storeLocation}\n" +
               "📊 Stock: ${product.availableQuantity} units available\n" +
               "⭐ Rating: ${product.rating}/5 (${product.reviewCount} reviews)\n\n" +
               "Available sizes: ${product.sizes.join(', ')}\n" +
               "Available colors: ${product.colors.join(', ')}\n\n" +
               "Perfect for fitness tracking! Want to know more?";
      }
    }
    
    if (query.contains('tshirt') || query.contains('t-shirt') || query.contains('shirt') || query.contains('cloth')) {
      final clothing = allProducts.where((p) => 
        p.name.toLowerCase().contains('shirt') || 
        p.category.toLowerCase().contains('fashion')
      ).toList();
      
      if (clothing.isNotEmpty) {
        final product = clothing.first;
        final discount = product.originalPrice != null 
            ? ((product.originalPrice! - product.price) / product.originalPrice! * 100).round()
            : 0;
        final priceText = product.originalPrice != null
            ? "💰 Price: ₹${product.price.toStringAsFixed(0)} (${discount}% OFF)\nOriginal Price: ₹${product.originalPrice!.toStringAsFixed(0)}\n\n"
            : "💰 Price: ₹${product.price.toStringAsFixed(0)}\n\n";
        return "👕 Found a great clothing option for you!\n\n" +
               "📦 ${product.name}\n" +
               "${product.description}\n\n" +
               priceText +
               "📍 Nearest Store: ${product.storeLocation}\n" +
               "📊 Stock: ${product.availableQuantity} units available\n" +
               "⭐ Rating: ${product.rating}/5 (${product.reviewCount} reviews)\n\n" +
               "Available sizes: ${product.sizes.join(', ')}\n" +
               "Available colors: ${product.colors.join(', ')}\n\n" +
               "Comfortable and stylish! Shall I add it to your cart?";
      }
    }
    
    // General product queries
    if (query.contains('product') || query.contains('item') || query.contains('buy') || query.contains('want')) {
      return "I can help you find the perfect product! We have:\n\n" +
             "👟 Athletic & Running Shoes\n" +
             "🎧 Premium Headphones\n" +
             "⌚ Smart Watches\n" +
             "👕 Fashion & Clothing\n" +
             "📱 Electronics\n\n" +
             "What specific product are you looking for?";
    }
    
    // Availability queries
    if (query.contains('available') || query.contains('stock') || query.contains('inventory')) {
      return "I can check product availability across all our stores. Please tell me which product you're interested in, and I'll find out where it's available.";
    }
    
    // Recommendation queries
    if (query.contains('recommend') || query.contains('suggest') || query.contains('best')) {
      return "Based on your preferences and our popular items, I recommend checking out our trending electronics section! We have great deals on smartphones, laptops, and smart home devices. Would you like specific recommendations?";
    }
    
    // Order tracking queries
    if (query.contains('order') || query.contains('track') || query.contains('delivery') || query.contains('shipping')) {
      return "I can help you track your orders! Your recent orders are being processed and will be delivered soon. Would you like me to check the status of a specific order?";
    }
    
    // Discount/offer queries
    if (query.contains('discount') || query.contains('offer') || query.contains('sale') || query.contains('deal')) {
      return "We have amazing offers right now! 🎉\n\n• Up to 50% off on Electronics\n• Buy 1 Get 1 on Fashion\n• 30% off on Home Decor\n• Free shipping on orders above ₹999\n\nWhich category interests you?";
    }
    
    // Store location queries
    if (query.contains('store') || query.contains('location') || query.contains('address') || query.contains('nearby')) {
      return "We have stores across multiple locations! Our main stores are in Bangalore, Mumbai, Delhi, and Chennai. I can help you find the nearest store to your location. Would you like directions?";
    }
    
    // Return/refund queries
    if (query.contains('return') || query.contains('refund') || query.contains('exchange')) {
      return "Our return policy allows returns within 30 days of purchase. Items must be unused and in original packaging. Refunds are processed within 5-7 business days. Would you like to initiate a return?";
    }
    
    // Payment queries
    if (query.contains('payment') || query.contains('pay') || query.contains('card') || query.contains('upi')) {
      return "We accept all major payment methods including Credit/Debit Cards, UPI, Net Banking, and Cash on Delivery. Your payments are 100% secure with us. How would you like to proceed?";
    }
    
    // Size/fit queries
    if (query.contains('size') || query.contains('fit') || query.contains('measurement')) {
      return "I can help you find the perfect size! We have a detailed size guide for all our products. For clothing, we offer sizes from XS to XXL. Would you like me to share the size chart?";
    }
    
    // Greeting
    if (query.contains('hello') || query.contains('hi') || query.contains('hey')) {
      return "Hello! 👋 I'm your AI shopping agent. I can help you with:\n\n• Finding products\n• Checking availability\n• Getting recommendations\n• Tracking orders\n• Store locations\n• Offers and discounts\n\nHow can I assist you today?";
    }
    
    // Thank you
    if (query.contains('thank') || query.contains('thanks')) {
      return "You're welcome! 😊 I'm always here to help. If you have any more questions about our products or services, feel free to ask!";
    }
    
    // Help queries
    if (query.contains('help') || query.contains('assist') || query.contains('support')) {
      return "I'm here to help! I can assist you with:\n\n✅ Product search and recommendations\n✅ Stock availability\n✅ Order tracking\n✅ Store locations\n✅ Offers and discounts\n✅ Returns and refunds\n✅ Payment information\n\nWhat would you like to know?";
    }
    
    // Default response
    return "I'm your AI shopping agent! I can help you find products, check availability, track orders, and answer questions about our services. What would you like to know?";
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showChatBottomSheet,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: const Icon(
        Icons.smart_toy,
        color: Colors.white,
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
