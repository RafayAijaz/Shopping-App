import 'package:ecommerce_app/pages/order_success_page.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/orders_provider.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Lets us validate every field in the form at once.
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  String paymentMethod = "Cash on Delivery";

  @override
  void dispose() {
    // Controllers hold resources, so free them when the page closes.
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String? _required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your $fieldName";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (digits.isEmpty) return "Please enter your phone number";
    if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(digits)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    final order = context.read<OrdersProvider>().placeOrder(
      items: cart.items,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      paymentMethod: paymentMethod,
    );
    cart.clear();

    // Remove every screen behind us, so "back" can't return to this form.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => OrderSuccessPage(order: order)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          // SingleChildScrollView (not ListView): a ListView only builds the
          // fields on screen, and fields that aren't built don't get validated.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Shipping details",
                  style: TextTheme.of(context).titleMedium,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "Full name",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _required(value, "name"),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Phone number",
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _addressController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Street address",
                    prefixIcon: Icon(Icons.home_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _required(value, "address"),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _cityController,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "City",
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _required(value, "city"),
                ),
                const SizedBox(height: 25),
                Text(
                  "Payment method",
                  style: TextTheme.of(context).titleMedium,
                ),
                const SizedBox(height: 5),
                RadioGroup<String>(
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                  child: const Column(
                    children: [
                      RadioListTile<String>(
                        value: "Cash on Delivery",
                        title: Text("Cash on Delivery"),
                        secondary: Icon(Icons.payments_outlined),
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<String>(
                        value: "Card",
                        enabled: false,
                        title: Text("Credit / Debit Card"),
                        subtitle: Text("Coming soon"),
                        secondary: Icon(Icons.credit_card),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text("Order summary", style: TextTheme.of(context).titleMedium),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.panel(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      for (final item in cart.items)
                        _SummaryRow(
                          label:
                              "${item.product.title} (Size ${item.size}) x${item.quantity}",
                          value: item.totalPrice,
                        ),
                      const Divider(height: 25),
                      _SummaryRow(label: "Subtotal", value: cart.subtotal),
                      _SummaryRow(
                        label: "Delivery",
                        value: cart.deliveryFee,
                        freeWhenZero: true,
                      ),
                      const Divider(height: 25),
                      _SummaryRow(
                        label: "Total",
                        value: cart.total,
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: cart.items.isEmpty ? null : _placeOrder,
                  child: Text(
                    "Place order  •  \$${cart.total.toStringAsFixed(2)}",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  final bool freeWhenZero;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.freeWhenZero = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.w900 : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 10),
          Text(
            freeWhenZero && value == 0
                ? "Free"
                : "\$${value.toStringAsFixed(2)}",
            style: style,
          ),
        ],
      ),
    );
  }
}
