import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/localization/app_localizations.dart';
import '../../core/utils/product_provider.dart';
import '../../core/widgets/product_card.dart';
import '../../models/product_model.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Relevance';
  List<String> _selectedBrands = [];
  RangeValues _priceRange = const RangeValues(0, 10000);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final productProvider = Provider.of<ProductProvider>(context);
    
    List<ProductModel> filteredProducts = _getFilteredProducts(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.discover),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, localizations),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: localizations.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('All', localizations),
                _buildCategoryChip('Electronics', localizations),
                _buildCategoryChip('Fashion', localizations),
                _buildCategoryChip('Home & Kitchen', localizations),
                _buildCategoryChip('Beauty & Personal Care', localizations),
                _buildCategoryChip('Sports & Outdoors', localizations),
              ],
            ),
          ),

          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.noItems,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, AppLocalizations localizations) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[800],
        ),
      ),
    );
  }

  List<ProductModel> _getFilteredProducts(ProductProvider provider) {
    List<ProductModel> products = provider.products;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = provider.searchProducts(_searchQuery);
    }

    // Filter by category
    if (_selectedCategory != 'All') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter by brands
    if (_selectedBrands.isNotEmpty) {
      products = products.where((p) => _selectedBrands.contains(p.brand)).toList();
    }

    // Filter by price range
    products = products
        .where((p) => p.price >= _priceRange.start && p.price <= _priceRange.end)
        .toList();

    // Sort products
    switch (_sortBy) {
      case 'Price: Low to High':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest First':
        // Assuming products are already in order
        break;
    }

    return products;
  }

  void _showSortSheet(BuildContext context, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.sortBy,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...[
                'Relevance',
                'Price: Low to High',
                'Price: High to Low',
                'Rating',
                'Newest First',
              ].map((sort) {
                return RadioListTile<String>(
                  title: Text(sort),
                  value: sort,
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.filter,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedBrands.clear();
                            _priceRange = const RangeValues(0, 10000);
                          });
                          setState(() {
                            _selectedBrands.clear();
                            _priceRange = const RangeValues(0, 10000);
                          });
                        },
                        child: Text(localizations.clearAll),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Price Range
                  Text(
                    '${localizations.price}: ₹${_priceRange.start.toInt()} - ₹${_priceRange.end.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    onChanged: (values) {
                      setModalState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Brands
                  Text(
                    localizations.brands,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        'SoundMax',
                        'FashionHub',
                        'TechWear',
                        'SportFit',
                        'HomeEssentials',
                        'GlowSkin',
                      ].map((brand) {
                        return CheckboxListTile(
                          title: Text(brand),
                          value: _selectedBrands.contains(brand),
                          onChanged: (checked) {
                            setModalState(() {
                              if (checked!) {
                                _selectedBrands.add(brand);
                              } else {
                                _selectedBrands.remove(brand);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text(localizations.apply),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
