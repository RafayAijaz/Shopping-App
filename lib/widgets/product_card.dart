
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String productImg;
  final Color backgroundColor;
  const ProductCard({
    required this.title,
    required this.price,
    required this.productImg,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height:  300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ,style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 5,),
            Text('\$${price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium,),
            SizedBox(height: 5,),
            Center(child: Image.asset(productImg, height: 175,)),
          ],
        ),
      ),
    );
  }
}
