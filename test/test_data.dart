import 'package:ecommerce_app/data/product_repository.dart';
import 'package:ecommerce_app/model/product.dart';

const nike = Product(
  id: '1',
  title: "Men's Nike Shoes",
  price: 44.52,
  imageUrl: 'assets/images/shoes_1.png',
  company: 'Nike',
  sizes: [9, 10, 11, 12],
);

const bata = Product(
  id: '2',
  title: "Bata Women's Shoes",
  price: 28.95,
  imageUrl: 'assets/images/shoes_3.png',
  company: 'Bata',
  sizes: [8, 9, 10],
);

const jordan = Product(
  id: '3',
  title: 'Jordan Shoes',
  price: 420.69,
  imageUrl: 'assets/images/shoes_4.png',
  company: 'Nike',
  sizes: [8, 9, 10],
);

const testProducts = [nike, bata, jordan];

// Returns products straight away instead of reading a file, so tests are
// fast and don't depend on files or the network.
class FakeProductRepository extends ProductRepository {
  final bool shouldFail;
  FakeProductRepository({this.shouldFail = false});

  @override
  Future<List<Product>> fetchProducts() async {
    if (shouldFail) throw Exception('No internet');
    return testProducts;
  }
}
