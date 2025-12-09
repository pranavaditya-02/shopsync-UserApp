/// Base class for all AI agents in the system
abstract class BaseAgent {
  final String agentId;
  final String agentName;
  final String description;

  BaseAgent({
    required this.agentId,
    required this.agentName,
    required this.description,
  });

  /// Process a request and return a response
  Future<AgentResponse> processRequest(AgentRequest request);

  /// Check if this agent can handle the given request
  bool canHandle(AgentRequest request);

  /// Get agent status
  AgentStatus getStatus() => AgentStatus.ready;
}

/// Request sent to an agent
class AgentRequest {
  final String requestId;
  final String customerId;
  final String requestType;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? conversationId;

  AgentRequest({
    required this.requestId,
    required this.customerId,
    required this.requestType,
    required this.data,
    DateTime? timestamp,
    this.conversationId,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'customerId': customerId,
        'requestType': requestType,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'conversationId': conversationId,
      };
}

/// Response from an agent
class AgentResponse {
  final String agentId;
  final bool success;
  final String message;
  final Map<String, dynamic> data;
  final List<String>? suggestedActions;
  final DateTime timestamp;

  AgentResponse({
    required this.agentId,
    required this.success,
    required this.message,
    required this.data,
    this.suggestedActions,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'agentId': agentId,
        'success': success,
        'message': message,
        'data': data,
        'suggestedActions': suggestedActions,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Agent status
enum AgentStatus {
  ready,
  busy,
  offline,
  error,
}
