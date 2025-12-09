import 'base_agent.dart';

/// Loyalty & Offers Agent - Manages loyalty points, discounts, and promotions
class LoyaltyAgent extends BaseAgent {
  // Customer loyalty data (in production, fetch from database)
  final Map<String, CustomerLoyalty> _customerLoyalty = {};

  LoyaltyAgent()
      : super(
          agentId: 'LOYALTY_AGENT',
          agentName: 'Loyalty & Offers Manager',
          description: 'Manages loyalty points, discounts, and promotional offers',
        );

  @override
  bool canHandle(AgentRequest request) {
    return [
      'get_applicable_offers',
      'calculate_benefits',
      'apply_coupon',
      'get_loyalty_status'
    ].contains(request.requestType);
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    switch (request.requestType) {
      case 'get_applicable_offers':
        return await _getApplicableOffers(request);
      case 'calculate_benefits':
        return await _calculateBenefits(request);
      case 'apply_coupon':
        return await _applyCoupon(request);
      case 'get_loyalty_status':
        return await _getLoyaltyStatus(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Unknown request type',
          data: {},
        );
    }
  }

  Future<AgentResponse> _getApplicableOffers(AgentRequest request) async {
    final productId = request.data['productId'] as String?;
    
    // Simulated offers
    final offers = [
      {
        'id': 'WINTER20',
        'type': 'percentage',
        'discount': 20,
        'description': '20% off on all products',
        'validUntil': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      },
      {
        'id': 'FIRST100',
        'type': 'flat',
        'discount': 100,
        'description': '₹100 off on orders above ₹500',
        'minOrderValue': 500,
      },
    ];

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Found ${offers.length} applicable offers',
      data: {
        'offers': offers,
        'count': offers.length,
      },
    );
  }

  Future<AgentResponse> _calculateBenefits(AgentRequest request) async {
    final customerId = request.customerId;
    final cartTotal = request.data['cartTotal'] as double;

    // Get or create customer loyalty data
    final loyalty = _customerLoyalty.putIfAbsent(
      customerId,
      () => CustomerLoyalty(
        customerId: customerId,
        tier: 'Gold',
        points: 500,
        pointsValue: 250, // 500 points = ₹250
      ),
    );

    // Calculate discounts
    double discount = 0;
    final availableOffers = <String, dynamic>{};

    // Loyalty points discount
    if (loyalty.points >= 100) {
      discount += loyalty.pointsValue;
      availableOffers['loyaltyPoints'] = {
        'points': loyalty.points,
        'value': loyalty.pointsValue,
      };
    }

    // Tier-based discount
    if (loyalty.tier == 'Gold') {
      final tierDiscount = cartTotal * 0.05; // 5% for Gold
      discount += tierDiscount;
      availableOffers['tierDiscount'] = {
        'tier': 'Gold',
        'percentage': 5,
        'amount': tierDiscount,
      };
    }

    // Bundle discount (if multiple items)
    final items = request.data['items'] as List?;
    if (items != null && items.length >= 2) {
      final bundleDiscount = cartTotal * 0.1; // 10% bundle discount
      discount += bundleDiscount;
      availableOffers['bundleDiscount'] = {
        'percentage': 10,
        'amount': bundleDiscount,
      };
    }

    final finalTotal = cartTotal - discount;

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'You\'re saving ₹${discount.toStringAsFixed(2)}!',
      data: {
        'originalTotal': cartTotal,
        'totalDiscount': discount,
        'finalTotal': finalTotal,
        'appliedOffers': availableOffers,
        'loyaltyTier': loyalty.tier,
        'pointsRemaining': loyalty.points,
      },
    );
  }

  Future<AgentResponse> _applyCoupon(AgentRequest request) async {
    final couponCode = request.data['couponCode'] as String;
    final cartTotal = request.data['cartTotal'] as double;

    // Validate coupon
    final coupon = _validateCoupon(couponCode);

    if (coupon == null) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: 'Invalid or expired coupon code',
        data: {},
      );
    }

    // Calculate discount
    double discount = 0;
    if (coupon['type'] == 'percentage') {
      discount = cartTotal * (coupon['discount'] as int) / 100;
    } else {
      discount = (coupon['discount'] as int).toDouble();
    }

    // Check minimum order value
    if (coupon['minOrderValue'] != null && cartTotal < coupon['minOrderValue']) {
      return AgentResponse(
        agentId: agentId,
        success: false,
        message: 'Minimum order value of ₹${coupon['minOrderValue']} required',
        data: {},
      );
    }

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Coupon applied! You saved ₹${discount.toStringAsFixed(2)}',
      data: {
        'couponCode': couponCode,
        'discount': discount,
        'finalTotal': cartTotal - discount,
      },
    );
  }

  Future<AgentResponse> _getLoyaltyStatus(AgentRequest request) async {
    final customerId = request.customerId;
    final loyalty = _customerLoyalty.putIfAbsent(
      customerId,
      () => CustomerLoyalty(
        customerId: customerId,
        tier: 'Silver',
        points: 250,
        pointsValue: 125,
      ),
    );

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'You are a ${loyalty.tier} member with ${loyalty.points} points',
      data: {
        'tier': loyalty.tier,
        'points': loyalty.points,
        'pointsValue': loyalty.pointsValue,
        'nextTierPoints': _getNextTierPoints(loyalty.tier),
      },
    );
  }

  Map<String, dynamic>? _validateCoupon(String code) {
    // Simulated coupon validation
    const validCoupons = {
      'WINTER20': {
        'type': 'percentage',
        'discount': 20,
        'minOrderValue': null,
      },
      'FIRST100': {
        'type': 'flat',
        'discount': 100,
        'minOrderValue': 500,
      },
      'SAVE50': {
        'type': 'flat',
        'discount': 50,
        'minOrderValue': 300,
      },
    };

    return validCoupons[code.toUpperCase()];
  }

  int _getNextTierPoints(String currentTier) {
    switch (currentTier) {
      case 'Bronze':
        return 500;
      case 'Silver':
        return 1000;
      case 'Gold':
        return 2000;
      case 'Platinum':
        return 0; // Max tier
      default:
        return 500;
    }
  }
}

class CustomerLoyalty {
  final String customerId;
  final String tier;
  final int points;
  final double pointsValue;

  CustomerLoyalty({
    required this.customerId,
    required this.tier,
    required this.points,
    required this.pointsValue,
  });
}
