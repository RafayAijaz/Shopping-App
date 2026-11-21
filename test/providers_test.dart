import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/order.dart';
import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/providers/favorites_provider.dart';
import 'package:ecommerce_app/providers/orders_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_data.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Product JSON', () {
    test('toJson and fromJson give back the same product', () {
      final copy = Product.fromJson(nike.toJson());

      expect(copy.id, nike.id);
      expect(copy.title, nike.title);
      expect(copy.price, nike.price);
      expect(copy.sizes, nike.sizes);
    });

    test('a whole-number price in JSON still becomes a double', () {
      final json = nike.toJson()..['price'] = 30;
      expect(Product.fromJson(json).price, 30.0);
    });
  });

  group('OrdersProvider', () {
    Order placeTestOrder(OrdersProvider orders, List<CartItem> items) {
      return orders.placeOrder(
        items: items,
        subtotal: 89.04,
        deliveryFee: 5.99,
        customerName: 'Test User',
        phone: '03001234567',
        address: '1 Test Street',
        city: 'Karachi',
        paymentMethod: 'Cash on Delivery',
      );
    }

    test('placing an order adds it to the top of the list', () {
      final orders = OrdersProvider();
      final order = placeTestOrder(orders, [
        CartItem(product: nike, size: 9, quantity: 2),
      ]);

      expect(orders.orders.first, order);
      expect(order.itemCount, 2);
      expect(order.total, closeTo(95.03, 0.001));
    });

    test('changing the cart later does not change a placed order', () {
      final orders = OrdersProvider();
      final cartItem = CartItem(product: nike, size: 9);
      final order = placeTestOrder(orders, [cartItem]);

      cartItem.quantity = 10;

      expect(order.items.first.quantity, 1);
    });

    test('orders are saved and loaded again after a restart', () async {
      final orders = OrdersProvider();
      placeTestOrder(orders, [CartItem(product: nike, size: 9)]);
      await Future<void>.delayed(Duration.zero);

      final reopened = OrdersProvider();
      await reopened.load();

      expect(reopened.orders.length, 1);
      expect(reopened.orders.first.city, 'Karachi');
      expect(reopened.orders.first.items.first.product.title, nike.title);
    });
  });

  group('FavoritesProvider', () {
    test('toggle adds and removes a favorite', () {
      final favorites = FavoritesProvider();

      favorites.toggle('1');
      expect(favorites.isFavorite('1'), isTrue);

      favorites.toggle('1');
      expect(favorites.isFavorite('1'), isFalse);
    });

    test('favorites are saved and loaded again after a restart', () async {
      final favorites = FavoritesProvider();
      favorites.toggle('3');
      await Future<void>.delayed(Duration.zero);

      final reopened = FavoritesProvider();
      await reopened.load();

      expect(reopened.isFavorite('3'), isTrue);
    });
  });
}
