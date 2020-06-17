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

  Future<void> toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    final option = json.encode({
      'isFavorite': isFavorite,
    });
    return http
        .patch("$_dburl/$id.json", body: option)
        .then((_) => notifyListeners());
  }
}

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  Product findById(String productId) =>
      _products.firstWhere((p) => p.id == productId);

  Future<void> removerProduct(String productId) {
    final deleteProductIndex = _products.indexWhere((p) => p.id == productId);
    final Product product = _products[deleteProductIndex];
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();

    return http.delete("$_dburl/$productId.json").catchError((err) {
      _products.insert(deleteProductIndex, product);
      return throw (err);
    });
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
    return http.post("$_dburl.json", body: productToJSON).then((res) {
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

  Future<void> updateProduct(Product product) {
    int existingProductIndex = _products.indexWhere((p) => p.id == product.id);
    return http
        .put("$_dburl/${product.id}.json", body: _productToJSON(product))
        .then((_) {
      _products[existingProductIndex] = product;
      notifyListeners();
    });
  }

  Future<void> refreshProducts() {
    return http.get("$_dburl.json").then((res) {
      final prodsdata = json.decode(res.body) as Map<Object, dynamic>;
      final List<Product> loadedProducts = [];
      if (prodsdata != null) {
        prodsdata.forEach((productId, value) {
          loadedProducts.add(Product(
            id: productId,
            title: value['title'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            description: value['description'],
            isFavorite: value['isFavorite'],
          ));
        });
        _products = loadedProducts;
      }
      notifyListeners();
    });
  }

  Future<void> fetchAndSetProducts() {
    if (_products.isEmpty) return refreshProducts();
    return Future.delayed(Duration.zero);
  }
}
