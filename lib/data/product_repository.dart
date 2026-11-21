import 'dart:convert';

import 'package:ecommerce_app/model/product.dart';
import 'package:flutter/services.dart';

// The only place in the app that knows WHERE products come from.
// Right now they're read from a JSON file bundled with the app. To load them
// from a real API, only this class has to change, for example:
//
//   final response = await http.get(Uri.parse('https://.../products'));
//   final list = jsonDecode(response.body) as List;
//
// The providers and pages stay exactly the same.
class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    final data = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(data) as List;
    return list
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
