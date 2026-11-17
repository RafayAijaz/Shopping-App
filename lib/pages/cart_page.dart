import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Details", style: TextTheme.of(context).titleMedium),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return ListTile(
            leading: CircleAvatar(child: Image.asset(item.product.imageUrl)),
            title: Text(item.product.title),
            subtitle: Text("Size: ${item.size}"),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Delete Product",
                        style: TextTheme.of(context).titleMedium,
                      ),
                      content: const Text(
                        "Are you sure you want to remove the product?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CartProvider>().removeItem(item);
                            Navigator.of(context).pop();
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
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
