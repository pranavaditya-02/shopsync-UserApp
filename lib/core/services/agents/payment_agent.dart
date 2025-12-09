import 'base_agent.dart';

/// Payment Agent - Handles payment processing
class PaymentAgent extends BaseAgent {
  PaymentAgent()
      : super(
          agentId: 'PAYMENT_AGENT',
          agentName: 'Payment Processor',
          description: 'Manages payment transactions and payment methods',
        );

  @override
  bool canHandle(AgentRequest request) {
    return ['process_payment', 'validate_payment_method', 'process_refund']
        .contains(request.requestType);
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    switch (request.requestType) {
      case 'process_payment':
        return await _processPayment(request);
      case 'validate_payment_method':
        return await _validatePaymentMethod(request);
      case 'process_refund':
        return await _processRefund(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Unknown request type',
          data: {},
        );
    }
  }

  Future<AgentResponse> _processPayment(AgentRequest request) async {
    final amount = request.data['amount'] as double;
    final paymentMethod = request.data['paymentMethod'] as String;
    final paymentDetails = request.data['paymentDetails'] as Map<String, dynamic>?;

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 1));

    // Simulate random payment failure (10% chance)
    final success = DateTime.now().millisecond % 10 != 0;

    if (!success) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: 'Payment failed: Insufficient balance. Try another payment method?',
        data: {
          'amount': amount,
          'paymentMethod': paymentMethod,
          'errorCode': 'INSUFFICIENT_BALANCE',
          'alternativeMethods': ['UPI', 'Card', 'Net Banking'],
        },
      );
    }

    final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Payment successful!',
      data: {
        'transactionId': transactionId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'SUCCESS',
      },
    );
  }

  Future<AgentResponse> _validatePaymentMethod(AgentRequest request) async {
    final paymentMethod = request.data['paymentMethod'] as String;
    final details = request.data['details'] as Map<String, dynamic>?;

    // Validate payment method
    final validMethods = ['Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Wallet', 'Cash on Delivery'];
    final isValid = validMethods.contains(paymentMethod);

    if (!isValid) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: 'Invalid payment method',
        data: {
          'validMethods': validMethods,
        },
      );
    }

    // Additional validation based on method
    if (paymentMethod == 'Credit Card' || paymentMethod == 'Debit Card') {
      final cardNumber = details?['cardNumber'] as String?;
      if (cardNumber == null || cardNumber.length < 16) {
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Invalid card details',
          data: {},
        );
      }
    }

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Payment method validated',
      data: {
        'paymentMethod': paymentMethod,
        'isValid': true,
      },
    );
  }

  Future<AgentResponse> _processRefund(AgentRequest request) async {
    final transactionId = request.data['transactionId'] as String;
    final amount = request.data['amount'] as double;
    final reason = request.data['reason'] as String?;

    // Simulate refund processing
    await Future.delayed(const Duration(milliseconds: 500));

    final refundId = 'REF${DateTime.now().millisecondsSinceEpoch}';

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Refund initiated. Amount will be credited in 5-7 business days.',
      data: {
        'refundId': refundId,
        'transactionId': transactionId,
        'amount': amount,
        'reason': reason,
        'status': 'INITIATED',
        'estimatedDays': 7,
      },
    );
  }
}
