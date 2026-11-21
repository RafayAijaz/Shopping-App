import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color backgroundColor;
  final String heroTag;
  const ProductCard({
    required this.product,
    required this.backgroundColor,
    required this.heroTag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(
      product.id,
    );

    return Container(
      margin: const EdgeInsets.all(20),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // Leaves room for the heart button on the right.
                  padding: const EdgeInsets.only(right: 40),
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextTheme.of(context).titleMedium,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextTheme.of(context).bodyMedium,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: heroTag,
                      child: Image.asset(product.imageUrl, height: 175),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              tooltip: isFavorite
                  ? "Remove from favorites"
                  : "Add to favorites",
              onPressed: () {
                context.read<FavoritesProvider>().toggle(product.id);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
