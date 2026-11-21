import 'package:ecommerce_app/providers/orders_provider.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:ecommerce_app/utils/date_format.dart';
import 'package:ecommerce_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  final VoidCallback? onStartShopping;
  const OrdersPage({this.onStartShopping, super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: orders.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long_outlined,
              title: "No orders yet",
              message: "When you place an order, it will show up here.",
              buttonText: "Start shopping",
              onPressed: onStartShopping,
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.panel(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // Tap an order to see what was in it.
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    title: Text(
                      "Order #${order.id}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${formatOrderDate(order.date)}\n${order.itemCount} ${order.itemCount == 1 ? "item" : "items"} | \$${order.total.toStringAsFixed(2)}",
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      for (final item in order.items)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            item.product.imageUrl,
                            width: 50,
                          ),
                          title: Text(item.product.title),
                          subtitle: Text(
                            "Size ${item.size} • Qty ${item.quantity}",
                          ),
                          trailing: Text(
                            "\$${item.totalPrice.toStringAsFixed(2)}",
                          ),
                        ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text("${order.address}, ${order.city}"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            order.deliveryFee == 0
                                ? "Free delivery"
                                : "Delivery \$${order.deliveryFee.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
