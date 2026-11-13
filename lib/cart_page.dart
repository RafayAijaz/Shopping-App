import 'package:ecommerce_app/global_variables.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Details", style: TextTheme.of(context).titleMedium,),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index){
          final item = cart[index];
          return ListTile(
            leading: CircleAvatar(child: Image.asset((item["imageUrl"]).toString() ),),
            title: Text(item["title"].toString()),
            subtitle: Text("size: ${item["sizes"]}"),
            trailing: Icon(Icons.delete, color: Colors.red,),
          );
        }),
    );
  }
}