import 'package:ecommerce_app/model/order.dart';
import 'package:ecommerce_app/pages/home_page.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  final Order order;
  const OrderSuccessPage({required this.order, super.key});

  void _openHome(BuildContext context, int tab) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialPage: tab)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 70, color: Colors.black),
                ),
                const SizedBox(height: 30),
                Text("Order placed!", style: TextTheme.of(context).titleLarge),
                const SizedBox(height: 10),
                Text(
                  "Thanks ${order.customerName}! Your shoes are on their way to ${order.city}.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.panel(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(label: "Order number", value: "#${order.id}"),
                      _InfoRow(label: "Items", value: "${order.itemCount}"),
                      _InfoRow(label: "Payment", value: order.paymentMethod),
                      _InfoRow(
                        label: "Total",
                        value: "\$${order.total.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _openHome(context, 0),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Continue shopping"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _openHome(context, 3),
                  child: const Text("View my orders"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
