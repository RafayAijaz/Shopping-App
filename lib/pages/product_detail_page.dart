import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({required this.product, super.key});

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
        const SnackBar(content: Text("Added to cart successfully")),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text("Please select a size")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details", style: TextTheme.of(context).bodySmall),
        centerTitle: true,
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
            // The image fills whatever space is left, so on small screens it
            // shrinks instead of pushing the bottom panel off the screen.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(product.imageUrl, fit: BoxFit.contain),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color.fromRGBO(245, 247, 249, 1),
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
                      itemCount: product.sizes.length,
                      itemBuilder: (context, index) {
                        final size = product.sizes[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              selectedSize = size;
                            }),
                            child: Chip(
                              label: Text(size.toString()),
                              backgroundColor: selectedSize == size
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
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
