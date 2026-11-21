import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/favorites_provider.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final String heroTag;
  const ProductDetailPage({
    required this.product,
    required this.heroTag,
    super.key,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedSize = 0;

  void onTap() {
    final messenger = ScaffoldMessenger.of(context);
    // Remove any snackbar that's still showing so repeated taps don't queue up.
    messenger.clearSnackBars();
    if (selectedSize != 0) {
      context.read<CartProvider>().addProduct(widget.product, selectedSize);
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Added to cart successfully"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Please select a size"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isFavorite = context.watch<FavoritesProvider>().isFavorite(
      product.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          IconButton(
            tooltip: isFavorite ? "Remove from favorites" : "Add to favorites",
            onPressed: () {
              context.read<FavoritesProvider>().toggle(product.id);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextTheme.of(context).titleLarge,
              ),
            ),
            Text(
              product.company,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            // The image fills whatever space is left, so on small screens it
            // shrinks instead of pushing the bottom panel off the screen.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                  tag: widget.heroTag,
                  child: Image.asset(product.imageUrl, fit: BoxFit.contain),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: AppColors.panel(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextTheme.of(context).titleLarge,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: product.sizes.length,
                      itemBuilder: (context, index) {
                        final size = product.sizes[index];
                        final isSelected = selectedSize == size;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                            label: Text(size.toString()),
                            selected: isSelected,
                            selectedColor: AppColors.yellow,
                            checkmarkColor: Colors.black,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : null,
                            ),
                            onSelected: (_) {
                              setState(() {
                                selectedSize = size;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.shopping_cart),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      label: const Text("Add to Cart"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
