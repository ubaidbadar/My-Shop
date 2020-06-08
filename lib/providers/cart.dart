import 'package:flutter/foundation.dart';
import 'package:myshop/providers/products.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      this.quantity = 1});
}

class Cart with ChangeNotifier {
  List<CartItem> _cart = [];

  List<CartItem> get cart => [..._cart];

  int get length {
    int totalItems = 0;
    for (CartItem ci in _cart) {
      totalItems += 1 * ci.quantity;
    }
    return totalItems;
  }

  void addToCart(Product product) {
    final int exciindex = _cart.indexWhere((ci) => ci.id == product.id);
    exciindex >= 0
        ? _cart[exciindex].quantity++
        : _cart.add(
            CartItem(
              id: product.id,
              title: product.title,
              price: product.price,
            ),
          );
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (CartItem ci in _cart) {
      total += ci.price * ci.quantity;
    }
    return total;
  }

  void removeFromCart(String cartItemId){
    _cart.removeWhere((ci) => ci.id == cartItemId);
    notifyListeners();
  }

  void removeSingleCartItem(String cartItemId) {
    int existingCartItemIndex = _cart.indexWhere((ci) => ci.id == cartItemId);
    _cart[existingCartItemIndex].quantity > 1
        ? _cart[existingCartItemIndex].quantity--
        : _cart.removeAt(existingCartItemIndex);
    notifyListeners();
  }
  void clearCart() => _cart = [];
}
