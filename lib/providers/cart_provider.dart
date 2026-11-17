import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier{

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);
 
 
 void addProduct(Product product, int size) {
    _items.add(CartItem(product: product, size: size));
    notifyListeners();
  }

    void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }


}