import 'package:flutter/foundation.dart';
import '../constants/db_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const _dburl = "$db_url/products";

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite;
  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    @required this.description,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class Products with ChangeNotifier {
  List<Product> _products = [];
  
  List<Product> get products => [..._products];

  Product findById(String productId) =>
      _products.firstWhere((p) => p.id == productId);

  void removerProduct(productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  String _productToJSON(Product product) => json.encode({
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      });

  Future<void> addProduct(Product product) {
    final productToJSON = _productToJSON(product);
    return http.post("$_dburl.json", body: productToJSON)
    .then((res) {
      final String productId = json.decode(res.body)['name'];
      _products.add(Product(
        id: productId,
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      ));
      notifyListeners();
    });
  }

  void updateProduct(Product product) {
    int existingProductIndex = _products.indexWhere((p) => p.id == product.id);
    if (existingProductIndex >= 0) {
      _products[existingProductIndex] = product;
      notifyListeners();
    }
  }
}
