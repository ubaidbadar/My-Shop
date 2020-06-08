import 'package:flutter/foundation.dart';
import 'package:myshop/providers/cart.dart';

class Order {
  final String id;
  final List<CartItem> cart;
  final double price;
  final DateTime dateTime;
  const Order({
    @required this.id,
    @required this.price,
    @required this.cart,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];
  List<Order> get orders => [..._orders];
  void addOrder(List<CartItem> cart, double price) {
    _orders.insert(
      0,
      Order(
        cart: cart,
        price: price,
        id: DateTime.now().toString(),
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
