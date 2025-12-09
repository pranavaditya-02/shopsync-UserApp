import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/agents/agent_manager.dart';
import '../services/agents/base_agent.dart';

/// AI Shopping Assistant Chat Widget
/// Provides intelligent assistance throughout the shopping journey
class AIAssistantButton extends StatefulWidget {
  final String? productId;
  final String? orderId;
  final Map<String, dynamic>? context;

  const AIAssistantButton({
    super.key,
    this.productId,
    this.orderId,
    this.context,
  });

  @override
  State<AIAssistantButton> createState() => _AIAssistantButtonState();
}

class _AIAssistantButtonState extends State<AIAssistantButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded) _buildQuickActions(),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
              
              if (!_isExpanded) {
                _showAIAssistantDialog();
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animationController,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.productId != null)
            _buildQuickActionButton(
              'Check Availability',
              Icons.inventory_2_outlined,
              () => _checkAvailability(widget.productId!),
            ),
          if (widget.orderId != null)
            _buildQuickActionButton(
              'Track Order',
              Icons.local_shipping_outlined,
              () => _trackOrder(widget.orderId!),
            ),
          _buildQuickActionButton(
            'Get Recommendations',
            Icons.lightbulb_outline,
            _getRecommendations,
          ),
          _buildQuickActionButton(
            'Chat with AI',
            Icons.chat_outlined,
            _showAIAssistantDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  void _checkAvailability(String productId) async {
    final agentManager = context.read<AgentManager>();
    _showLoadingDialog('Checking availability...');

    final response = await agentManager.checkAvailability(
      customerId: 'user123', // Replace with actual user ID
      productId: productId,
      location: 'Mumbai', // Get from user's location
    );

    Navigator.pop(context); // Close loading
    _showResponseDialog(response);
  }

  void _trackOrder(String orderId) async {
    final agentManager = context.read<AgentManager>();
    _showLoadingDialog('Tracking your order...');

    final response = await agentManager.trackOrder(
      customerId: 'user123',
      orderId: orderId,
    );

    Navigator.pop(context);
    _showResponseDialog(response);
  }

  void _getRecommendations() async {
    final agentManager = context.read<AgentManager>();
    _showLoadingDialog('Finding perfect products for you...');

    final response = await agentManager.searchProducts(
      customerId: 'user123',
      query: widget.context?['category'] ?? 'trending',
    );

    Navigator.pop(context);
    _showResponseDialog(response);
  }

  void _showAIAssistantDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AIAssistantSheet(
        productId: widget.productId,
        orderId: widget.orderId,
      ),
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _showResponseDialog(AgentResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              response.success ? Icons.check_circle : Icons.error,
              color: response.success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            const Expanded(child: Text('AI Assistant')),
          ],
        ),
        content: Text(response.message),
        actions: [
          if (response.suggestedActions != null)
            ...response.suggestedActions!.map((action) => TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(action),
                )),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Full AI Assistant Chat Sheet
class AIAssistantSheet extends StatefulWidget {
  final String? productId;
  final String? orderId;

  const AIAssistantSheet({
    super.key,
    this.productId,
    this.orderId,
  });

  @override
  State<AIAssistantSheet> createState() => _AIAssistantSheetState();
}

class _AIAssistantSheetState extends State<AIAssistantSheet> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      isUser: false,
      message:
          "Hi! I'm your AI shopping assistant. How can I help you today?\n\n"
          "I can help you with:\n"
          "• Finding products\n"
          "• Checking availability\n"
          "• Tracking orders\n"
          "• Getting discounts",
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.smart_toy, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Shopping Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Online • Ready to help',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('AI is thinking...'),
                ],
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        isUser: true,
        message: message,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _messageController.clear();

    // Process with AI Agent
    final agentManager = context.read<AgentManager>();
    final response = await agentManager.sendRequest(
      customerId: 'user123',
      requestType: 'general_query',
      data: {'query': message},
    );

    setState(() {
      _messages.add(ChatMessage(
        isUser: false,
        message: response.message,
        timestamp: DateTime.now(),
      ));
      _isLoading = false;
    });
  }
}

class ChatMessage {
  final bool isUser;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.isUser,
    required this.message,
    required this.timestamp,
  });
}
