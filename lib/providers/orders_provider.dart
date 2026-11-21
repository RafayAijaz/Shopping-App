import 'dart:convert';

import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersProvider extends ChangeNotifier {
  static const _storageKey = 'orders';

  final List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);

  Order placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required String customerName,
    required String phone,
    required String address,
    required String city,
    required String paymentMethod,
  }) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      // Copy the items, so changing the cart later can't change this order.
      items: items
          .map(
            (item) => CartItem(
              product: item.product,
              size: item.size,
              quantity: item.quantity,
            ),
          )
          .toList(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      date: DateTime.now(),
      customerName: customerName,
      phone: phone,
      address: address,
      city: city,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order); // newest first
    notifyListeners();
    _save();
    return order;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == null) return;

    final list = jsonDecode(saved) as List;
    _orders
      ..clear()
      ..addAll(list.map((e) => Order.fromJson(e as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_orders.map((order) => order.toJson()).toList());
    await prefs.setString(_storageKey, json);
  }
}
