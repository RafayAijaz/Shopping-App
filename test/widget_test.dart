import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/main.dart';

void main() {
  testWidgets('home page shows the product list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Shoes \nCollection'), findsOneWidget);
    expect(find.text("Men's Nike Shoes"), findsOneWidget);
  });
}
