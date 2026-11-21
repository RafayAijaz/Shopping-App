import "package:ecommerce_app/pages/cart_page.dart";
import "package:ecommerce_app/pages/favorites_page.dart";
import "package:ecommerce_app/pages/orders_page.dart";
import "package:ecommerce_app/providers/cart_provider.dart";
import "package:ecommerce_app/widgets/product_list.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  // Lets other screens open the app on a specific tab,
  // e.g. "View my orders" after checkout opens tab 3.
  final int initialPage;
  const HomePage({this.initialPage = 0, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int selectedPage;

  @override
  void initState() {
    super.initState();
    selectedPage = widget.initialPage;
  }

  void goToShop() {
    setState(() {
      selectedPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;

    // Built here (not as a field) so the callbacks can call setState.
    final pages = [
      const ProductList(),
      FavoritesPage(onStartShopping: goToShop),
      CartPage(onStartShopping: goToShop),
      OrdersPage(onStartShopping: goToShop),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedPage, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedPage = value;
          });
        },
        currentIndex: selectedPage,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text("$cartCount"),
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_bag),
            ),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
        ],
      ),
    );
  }
}
