import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/pages/product_detail_page.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:flutter/material.dart';

// Shows products in one column on phones and 2-3 columns on tablets and web.
class ProductGrid extends StatelessWidget {
  final List<Product> products;

  // Two products can be on screen in different tabs (Home and Favorites).
  // Each Hero needs a unique tag, so every screen passes its own prefix.
  final String heroPrefix;

  const ProductGrid({
    required this.products,
    required this.heroPrefix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 450).floor().clamp(1, 3);

        return GridView.builder(
          // Lets pull-to-refresh work even when the list is short.
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 340, // card height 300 + margin 20 on each side
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final heroTag = "$heroPrefix-${product.id}";

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailPage(product: product, heroTag: heroTag),
                  ),
                );
              },
              child: ProductCard(
                product: product,
                heroTag: heroTag,
                backgroundColor: AppColors.card(context, index),
              ),
            );
          },
        );
      },
    );
  }
}
