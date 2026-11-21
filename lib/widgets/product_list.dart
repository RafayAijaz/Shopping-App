import 'package:ecommerce_app/model/product.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/theme/app_theme.dart';
import 'package:ecommerce_app/widgets/empty_state.dart';
import 'package:ecommerce_app/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SortOption {
  featured("Featured"),
  priceLowToHigh("Price: Low to High"),
  priceHighToLow("Price: High to Low"),
  nameAToZ("Name: A to Z");

  final String label;
  const SortOption(this.label);
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String selectedFilter = 'All';
  String searchQuery = '';
  SortOption sortOption = SortOption.featured;

  List<Product> _visibleProducts(List<Product> products) {
    final query = searchQuery.toLowerCase();

    final result = products.where((p) {
      final matchesFilter =
          selectedFilter == 'All' || p.company == selectedFilter;
      final matchesSearch =
          p.title.toLowerCase().contains(query) ||
          p.company.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();

    switch (sortOption) {
      case SortOption.featured:
        break;
      case SortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.nameAToZ:
        result.sort((a, b) => a.title.compareTo(b.title));
    }
    return result;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Sort by", style: TextTheme.of(context).titleMedium),
              const SizedBox(height: 10),
              for (final option in SortOption.values)
                ListTile(
                  title: Text(option.label),
                  trailing: sortOption == option
                      ? const Icon(Icons.check, color: AppColors.yellow)
                      : null,
                  onTap: () {
                    setState(() {
                      sortOption = option;
                    });
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;

    // Built from the products themselves, so there's a chip for every brand
    // and never one for a brand with no products. The {...} set removes duplicates.
    final filters = [
      'All',
      ...{for (final p in products) p.company},
    ];
    final visibleProducts = _visibleProducts(products);

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
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Text(
                    "Shoes \nCollection",
                    style: TextTheme.of(context).titleLarge,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "Toggle dark mode",
                  onPressed: () {
                    context.read<ThemeProvider>().toggleTheme(
                      Theme.of(context).brightness,
                    );
                  },
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Row(
              children: [
                IconButton(
                  tooltip: "Sort",
                  onPressed: _showSortSheet,
                  icon: Badge(
                    // A small dot shows when a sort other than "Featured" is on.
                    isLabelVisible: sortOption != SortOption.featured,
                    smallSize: 8,
                    child: const Icon(Icons.tune),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
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
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      showCheckmark: false,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      selectedColor: AppColors.yellow,
                      backgroundColor: AppColors.panel(context),
                      side: BorderSide(color: AppColors.panel(context)),
                      labelStyle: TextStyle(
                        fontSize: 19,
                        color: isSelected ? Colors.black : null,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(child: _buildProducts(productProvider, visibleProducts)),
          ],
        ),
      ),
    );
  }

  Widget _buildProducts(ProductProvider provider, List<Product> visible) {
    if (provider.isLoading && provider.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.products.isEmpty) {
      return EmptyState(
        icon: Icons.wifi_off,
        title: "Something went wrong",
        message: provider.error!,
        buttonText: "Retry",
        onPressed: provider.fetchProducts,
      );
    }

    if (visible.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: "No products found",
        message: "Try a different search or filter.",
      );
    }

    return RefreshIndicator(
      onRefresh: provider.fetchProducts,
      child: ProductGrid(products: visible, heroPrefix: "home"),
    );
  }
}
