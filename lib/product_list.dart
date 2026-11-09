import 'package:ecommerce_app/product_card.dart';
import 'package:ecommerce_app/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'global_variables.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const ["All", "Addidas", "Nike", "Bata"];
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(20),
                  child: Text(
                    "Shoes \nCollection",
                    style: TextTheme.of(context).titleLarge,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(25),
                      prefixIcon: Icon(Icons.search),

                      hintText: "Search",
                      border: border,
                      enabledBorder: border,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(50),
                        ),
                        label: Text(filter),
                        backgroundColor: selectedFilter == filter
                            ? Theme.of(context).colorScheme.primary
                            : Color.fromRGBO(245, 247, 249, 1),
                        side: BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                        labelStyle: TextStyle(fontSize: 19),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) =>
                              ProductDetailPage(product: product)),
                        ),
                      );
                    },
                    child: ProductCard(
                      title: product["title"].toString(),
                      price: 250,
                      productImg: product["imageUrl"].toString(),
                      backgroundColor: index.isEven
                          ? const Color.fromRGBO(216, 210, 253, 1)
                          : const Color.fromRGBO(245, 247, 249, 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
