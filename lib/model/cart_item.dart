import 'package:ecommerce_app/model/product.dart';

class CartItem {
  final Product product;
  final int size;
  int quantity;
  CartItem({required this.product, required this.size, this.quantity = 1});
}
