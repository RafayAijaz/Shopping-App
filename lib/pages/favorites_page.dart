import 'package:ecommerce_app/providers/favorites_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/widgets/empty_state.dart';
import 'package:ecommerce_app/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  final VoidCallback? onStartShopping;
  const FavoritesPage({this.onStartShopping, super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final products = context
        .watch<ProductProvider>()
        .products
        .where((p) => favorites.isFavorite(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: products.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              title: "No favorites yet",
              message: "Tap the heart on any shoe to save it here.",
              buttonText: "Browse shoes",
              onPressed: onStartShopping,
            )
          : ProductGrid(products: products, heroPrefix: "favorites"),
    );
  }
}
