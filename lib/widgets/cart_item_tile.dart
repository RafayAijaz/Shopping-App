import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  const CartItemTile({required this.item, super.key});

  void _confirmRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            "Delete Product",
            style: TextTheme.of(dialogContext).titleMedium,
          ),
          content: const Text("Are you sure you want to remove the product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<CartProvider>().removeItem(item);
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.panel(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(item.product.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Size: ${item.size}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${item.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "Decrease quantity",
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              // At quantity 1, "-" would remove the item, so ask first.
              if (item.quantity == 1) {
                _confirmRemove(context);
              } else {
                cart.decrement(item);
              }
            },
          ),
          Text("${item.quantity}", style: TextTheme.of(context).titleMedium),
          IconButton(
            tooltip: "Increase quantity",
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => cart.increment(item),
          ),
        ],
      ),
    );
  }
}
