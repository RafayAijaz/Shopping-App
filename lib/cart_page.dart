import 'package:ecommerce_app/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
  
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
            trailing: IconButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Delete Product", style: TextTheme.of(context).titleMedium,),
                  content: Text("Are you sure you want to remove the product?"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("No", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),)),
                    TextButton(onPressed: (){
                      context.read<CartProvider>().removeProduct(item);
                      Navigator.of(context).pop();
                    }, child: Text("Yes", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),))
                  ],
                );
              });
            }, icon: Icon(Icons.delete, color: Colors.red,))
          );
        }),
    );
  }
}