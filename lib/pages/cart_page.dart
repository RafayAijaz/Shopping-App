import 'package:ecommerce_app/pages/checkout_page.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:ecommerce_app/widgets/cart_item_tile.dart';
import 'package:ecommerce_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final VoidCallback? onStartShopping;
  const CartPage({this.onStartShopping, super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.items;

    return Scaffold(
      appBar: AppBar(title: const Text("Cart Details")),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: "Your cart is empty",
              message: "Looks like you haven't added any shoes yet.",
              buttonText: "Start shopping",
              onPressed: onStartShopping,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 6),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];

                      return Dismissible(
                        // Flutter uses the key to know WHICH row was swiped,
                        // so it must be unique: product id + size.
                        key: ValueKey("${item.product.id}-${item.size}"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 25),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          // Read the provider now: once the row is gone, its
                          // context can't be used by the Undo button anymore.
                          final provider = context.read<CartProvider>();
                          provider.removeItem(item);
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Text("${item.product.title} removed"),
                                action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () {
                                    provider.insertItem(index, item);
                                  },
                                ),
                              ),
                            );
                        },
                        child: CartItemTile(item: item),
                      );
                    },
                  ),
                ),
                const _CartTotalBar(),
              ],
            ),
    );
  }
}

class _CartTotalBar extends StatelessWidget {
  const _CartTotalBar();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final amountForFreeDelivery =
        CartProvider.freeDeliveryThreshold - cart.subtotal;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: AppColors.panel(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (amountForFreeDelivery > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Add \$${amountForFreeDelivery.toStringAsFixed(2)} more for free delivery",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total (${cart.totalCount} ${cart.totalCount == 1 ? "item" : "items"})",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "\$${cart.subtotal.toStringAsFixed(2)}",
                      style: TextTheme.of(context).titleLarge,
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CheckoutPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
