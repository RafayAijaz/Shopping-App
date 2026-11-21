import 'package:ecommerce_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_data.dart';

Future<void> startApp(WidgetTester tester, {bool failToLoad = false}) async {
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(
    MyApp(
      productRepository: FakeProductRepository(shouldFail: failToLoad),
      showSplash: false,
    ),
  );
  await tester.pumpAndSettle(); // wait for products to load
}

void main() {
  testWidgets('splash shows the logo and title, then opens the home page', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MyApp(productRepository: FakeProductRepository()));

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('SHOEHUB', findRichText: true), findsOneWidget);

    await tester.pump(const Duration(seconds: 3)); // splash timer ends
    await tester.pumpAndSettle(); // fade to the home page

    expect(find.text('Shoes \nCollection'), findsOneWidget);
  });

  testWidgets('shows an error with a retry button when loading fails', (
    tester,
  ) async {
    await startApp(tester, failToLoad: true);

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('home page shows the product list', (tester) async {
    await startApp(tester);

    expect(find.text('Shoes \nCollection'), findsOneWidget);
    expect(find.text("Men's Nike Shoes"), findsOneWidget);
  });

  testWidgets('brand filter only shows that brand', (tester) async {
    await startApp(tester);

    await tester.tap(find.text('Bata'));
    await tester.pumpAndSettle();

    expect(find.text("Bata Women's Shoes"), findsOneWidget);
    expect(find.text("Men's Nike Shoes"), findsNothing);
  });

  testWidgets('search filters by title', (tester) async {
    await startApp(tester);

    await tester.enterText(find.byType(TextField), 'jordan');
    await tester.pumpAndSettle();

    expect(find.text('Jordan Shoes'), findsOneWidget);
    expect(find.text("Men's Nike Shoes"), findsNothing);
  });

  testWidgets('search with no results shows an empty state', (tester) async {
    await startApp(tester);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pumpAndSettle();

    expect(find.text('No products found'), findsOneWidget);
  });

  testWidgets('full flow: add to cart, checkout, see the order', (
    tester,
  ) async {
    await startApp(tester);

    // Open the product.
    await tester.tap(find.text("Men's Nike Shoes"));
    await tester.pumpAndSettle();

    // A size is required.
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();
    expect(find.text('Please select a size'), findsOneWidget);

    await tester.tap(find.text('9'));
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();
    expect(find.text('Added to cart successfully'), findsOneWidget);

    // Back on the home page, the cart badge shows 1 item.
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Wait for the snackbar to disappear so it doesn't cover the cart buttons.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(Badge, '1'), findsOneWidget);

    // The cart shows the item and the total.
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    expect(find.text("Men's Nike Shoes"), findsOneWidget);
    expect(find.text('Total (1 item)'), findsOneWidget);

    // Checkout: submitting an empty form shows errors.
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    final placeOrder = find.textContaining('Place order');
    // Text fields have their own scrollables, so name the form's scroll view.
    final form = find
        .descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(placeOrder, 300, scrollable: form);
    await tester.tap(placeOrder);
    await tester.pumpAndSettle();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);

    // Fill in the form and place the order.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Test User',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone number'),
      '03001234567',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Street address'),
      '1 Test Street',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'City'),
      'Karachi',
    );
    await tester.scrollUntilVisible(placeOrder, 300, scrollable: form);
    await tester.tap(placeOrder);
    await tester.pumpAndSettle();

    expect(find.text('Order placed!'), findsOneWidget);

    // The order shows up in order history, and the cart is empty.
    await tester.tap(find.text('View my orders'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Order #'), findsOneWidget);
    expect(find.widgetWithText(Badge, '1'), findsNothing);
  });
}
