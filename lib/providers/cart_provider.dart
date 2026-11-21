import 'dart:convert';

import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  static const _storageKey = 'cart';
  static const freeDeliveryThreshold = 100.0;
  static const deliveryCharge = 5.99;

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  // Delivery is free on orders over $100.
  double get deliveryFee {
    if (_items.isEmpty || subtotal >= freeDeliveryThreshold) return 0;
    return deliveryCharge;
  }

  double get total => subtotal + deliveryFee;

  void addProduct(Product product, int size) {
    // Same product in the same size? Increase its quantity instead of adding
    // a second row. Ids are compared (not objects) so this still works when
    // products are loaded again from JSON.
    final index = _items.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product, size: size));
    }
    _changed();
  }

  void increment(CartItem item) {
    item.quantity++;
    _changed();
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    _changed();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    _changed();
  }

  // Used by the "Undo" button after swiping an item away.
  void insertItem(int index, CartItem item) {
    _items.insert(index.clamp(0, _items.length), item);
    _changed();
  }

  void clear() {
    _items.clear();
    _changed();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == null) return;

    final list = jsonDecode(saved) as List;
    _items
      ..clear()
      ..addAll(list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)));
    notifyListeners();
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_storageKey, json);
  }
}
