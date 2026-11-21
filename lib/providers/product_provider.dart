import 'package:ecommerce_app/data/product_repository.dart';
import 'package:ecommerce_app/model/product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  ProductProvider({ProductRepository? repository})
    : _repository = repository ?? ProductRepository();

  List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);

  bool isLoading = false;
  String? error;

  Future<void> fetchProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _products = await _repository.fetchProducts();
    } catch (e) {
      error = "Couldn't load products. Please try again.";
    }

    isLoading = false;
    notifyListeners();
  }
}
