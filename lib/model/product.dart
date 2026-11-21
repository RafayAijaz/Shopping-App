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

  // Used when products come in as JSON (from the products.json file, an API,
  // or the saved cart).
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      company: json['company'] as String,
      price: (json['price'] as num).toDouble(),
      sizes: List<int>.from(json['sizes'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'company': company,
      'price': price,
      'sizes': sizes,
    };
  }
}
