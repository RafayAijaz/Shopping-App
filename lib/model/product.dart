class Product {
  final String id, title, imageUrl, company;
  final double price;
  final List<int> sizes;
  const Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.company,
    required this.price,
    required this.sizes,
  });
}
