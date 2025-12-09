import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/localization/app_localizations.dart';
import '../../core/utils/product_provider.dart';
import '../../core/widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${localizations.wishlist} (${productProvider.wishlist.length})'),
      ),
      body: productProvider.wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.emptyWishlist,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: productProvider.wishlist.length,
              itemBuilder: (context, index) {
                return ProductCard(product: productProvider.wishlist[index]);
              },
            ),
    );
  }
}
