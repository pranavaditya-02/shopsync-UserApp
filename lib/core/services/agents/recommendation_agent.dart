import 'base_agent.dart';
import '../../utils/product_provider.dart';
import '../../../models/product_model.dart';

/// Recommendation Agent - Suggests products based on customer preferences
class RecommendationAgent extends BaseAgent {
  final ProductProvider _productProvider;

  RecommendationAgent({required ProductProvider productProvider})
      : _productProvider = productProvider,
        super(
          agentId: 'RECOMMENDATION_AGENT',
          agentName: 'Product Recommendation Specialist',
          description: 'Suggests personalized product recommendations',
        );

  @override
  bool canHandle(AgentRequest request) {
    return ['get_recommendations', 'get_complementary_products', 'get_similar_products']
        .contains(request.requestType);
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    switch (request.requestType) {
      case 'get_recommendations':
        return await _getRecommendations(request);
      case 'get_complementary_products':
        return await _getComplementaryProducts(request);
      case 'get_similar_products':
        return await _getSimilarProducts(request);
      default:
        return AgentResponse(
          agentId: agentId,
          success: false,
          message: 'Unknown request type',
          data: {},
        );
    }
  }

  Future<AgentResponse> _getRecommendations(AgentRequest request) async {
    final query = request.data['query'] as String?;
    final category = request.data['category'] as String?;
    final maxPrice = request.data['maxPrice'] as double?;

    List<ProductModel> products = _productProvider.products;

    // Filter by category
    if (category != null && category != 'All') {
      products = products.where((p) => p.category == category).toList();
    }

    // Filter by price
    if (maxPrice != null) {
      products = products.where((p) => p.price <= maxPrice).toList();
    }

    // Search by query
    if (query != null && query.isNotEmpty) {
      products = _productProvider.searchProducts(query);
    }

    // Sort by rating and popularity
    products.sort((a, b) => b.rating.compareTo(a.rating));

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Found ${products.length} recommendations',
      data: {
        'products': products.map((p) => {
          'id': p.id,
          'name': p.name,
          'price': p.price,
          'rating': p.rating,
          'imageUrl': p.imageUrl,
          'brand': p.brand,
        }).toList(),
        'count': products.length,
      },
    );
  }

  Future<AgentResponse> _getComplementaryProducts(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final product = _productProvider.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => _productProvider.products.first,
    );

    // Get products from same category
    final complementary = _productProvider.products
        .where((p) => p.category == product.category && p.id != productId)
        .take(3)
        .toList();

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Found ${complementary.length} complementary products',
      data: {
        'products': complementary.map((p) => {
          'id': p.id,
          'name': p.name,
          'price': p.price,
          'imageUrl': p.imageUrl,
        }).toList(),
      },
    );
  }

  Future<AgentResponse> _getSimilarProducts(AgentRequest request) async {
    final productId = request.data['productId'] as String;
    final product = _productProvider.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => _productProvider.products.first,
    );

    // Get products from same brand or category
    final similar = _productProvider.products
        .where((p) => 
            (p.brand == product.brand || p.category == product.category) && 
            p.id != productId)
        .take(4)
        .toList();

    return AgentResponse(
      agentId: agentId,
      success: true,
      message: 'Found ${similar.length} similar products',
      data: {
        'products': similar.map((p) => {
          'id': p.id,
          'name': p.name,
          'price': p.price,
          'imageUrl': p.imageUrl,
        }).toList(),
      },
    );
  }
}
