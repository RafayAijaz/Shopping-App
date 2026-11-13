import "package:ecommerce_app/cart_provider.dart";
import "package:ecommerce_app/home_page.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: "Shopping App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          inputDecorationTheme: InputDecorationTheme(
            prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(254, 206, 1, 1),
            primary: Color.fromRGBO(254, 206, 1, 1),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              fontFamily: "Lato",
            ),
            titleMedium: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            bodySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
          ),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}
