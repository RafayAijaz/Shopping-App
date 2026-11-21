import 'package:ecommerce_app/model/product.dart';

class CartItem {
  final Product product;
  final int size;
  int quantity;
  CartItem({required this.product, required this.size, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      size: json['size'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'size': size, 'quantity': quantity};
  }
}
