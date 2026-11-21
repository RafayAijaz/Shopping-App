import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_data.dart';

void main() {
  late CartProvider cart;

  setUp(() {
    // A fake, empty storage for every test.
    SharedPreferences.setMockInitialValues({});
    cart = CartProvider();
  });

  test('adding the same product and size twice increases the quantity', () {
    cart.addProduct(nike, 9);
    cart.addProduct(nike, 9);

    expect(cart.items.length, 1);
    expect(cart.items.first.quantity, 2);
    expect(cart.totalCount, 2);
  });

  test('the same product in a different size is a separate item', () {
    cart.addProduct(nike, 9);
    cart.addProduct(nike, 10);

    expect(cart.items.length, 2);
  });

  test('subtotal accounts for quantity', () {
    cart.addProduct(nike, 9);
    cart.addProduct(nike, 9);

    // closeTo, because decimal math isn't exact (44.52 * 2 = 89.0399999...)
    expect(cart.subtotal, closeTo(89.04, 0.001));
  });

  test('delivery is charged under \$100 and free from \$100', () {
    expect(cart.deliveryFee, 0); // empty cart

    cart.addProduct(nike, 9);
    expect(cart.deliveryFee, CartProvider.deliveryCharge);
    expect(cart.total, closeTo(44.52 + 5.99, 0.001));

    cart.addProduct(jordan, 9);
    expect(cart.deliveryFee, 0);
  });

  test('decrement at quantity 1 removes the item', () {
    cart.addProduct(nike, 9);
    cart.decrement(cart.items.first);

    expect(cart.items, isEmpty);
  });

  test('insertItem puts a removed item back in the same place (undo)', () {
    cart.addProduct(nike, 9);
    cart.addProduct(jordan, 9);
    final removed = cart.items.first;

    cart.removeItem(removed);
    cart.insertItem(0, removed);

    expect(cart.items.first.product.id, nike.id);
    expect(cart.items.length, 2);
  });

  test('clear empties the cart', () {
    cart.addProduct(nike, 9);
    cart.addProduct(jordan, 10);
    cart.clear();

    expect(cart.items, isEmpty);
    expect(cart.total, 0);
  });

  test('the cart is saved and loaded again after a restart', () async {
    cart.addProduct(nike, 9);
    cart.addProduct(nike, 9);
    cart.addProduct(jordan, 10);
    await Future<void>.delayed(Duration.zero); // let the save finish

    // A brand-new provider is like opening the app again.
    final reopened = CartProvider();
    await reopened.load();

    expect(reopened.items.length, 2);
    expect(reopened.items.first.product.title, "Men's Nike Shoes");
    expect(reopened.items.first.quantity, 2);
    expect(reopened.items.last.size, 10);
  });
}
