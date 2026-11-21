import "package:ecommerce_app/data/product_repository.dart";
import "package:ecommerce_app/pages/home_page.dart";
import "package:ecommerce_app/providers/cart_provider.dart";
import "package:ecommerce_app/providers/favorites_provider.dart";
import "package:ecommerce_app/providers/orders_provider.dart";
import "package:ecommerce_app/providers/product_provider.dart";
import "package:ecommerce_app/providers/theme_provider.dart";
import "package:ecommerce_app/theme/app_theme.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Tests pass a fake repository here; the real app uses the default one.
  final ProductRepository? productRepository;
  const MyApp({this.productRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ".." calls fetchProducts()/load() and still returns the provider.
        ChangeNotifierProvider(
          create: (context) =>
              ProductProvider(repository: productRepository)..fetchProducts(),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()..load()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()..load()),
        ChangeNotifierProvider(
          create: (context) => FavoritesProvider()..load(),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()..load()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: "ShoeHub",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
