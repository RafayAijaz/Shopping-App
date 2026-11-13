import 'package:ecommerce_app/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, Object> product;
  const ProductDetailPage({required this.product, super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedSize = 0;
  void onTap() {
    if (selectedSize != 0) {
      context.read<CartProvider>().addProducts({
        'id': widget.product['id'],
        'title': widget.product['title'],
        'price': widget.product['price'],
        'imageUrl': widget.product['imageUrl'],
        'company': widget.product['company'],
        'sizes': selectedSize,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart successfully")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a size")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details", style: TextTheme.of(context).bodySmall),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.product["title"].toString(),
              style: TextTheme.of(context).titleLarge,
            ),
            Spacer(),
            Image.asset(widget.product["imageUrl"] as String),
            Spacer(flex: 2),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color.fromRGBO(245, 247, 249, 1),
              ),
              child: Column(
                children: [
                  Text(
                    "\$ ${widget.product["price"]}",
                    style: TextTheme.of(context).titleLarge,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (widget.product["sizes"] as List<int>).length,
                      itemBuilder: (context, index) {
                        final size =
                            (widget.product["sizes"] as List<int>)[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              selectedSize = size;
                            }),
                            child: Chip(
                              label: Text(size.toString()),
                              backgroundColor: selectedSize == size
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: Icon(Icons.shopping_cart, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      label: Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
