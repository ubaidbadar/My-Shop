import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import '../constants/db_url.dart';
import 'package:http/http.dart' as http;

const _dburl = "$db_url/orders";

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

  String _toJson(Order order) {
    return json.encode({
      'price': order.price,
      'dateTime': order.dateTime.toIso8601String(),
      'products': order.cart
          .map((ci) => json.encode({
                'title': ci.title,
                'price': ci.price,
                'quantity': ci.quantity,
                'id': ci.id,
              }))
          .toList(),
    });
  }

  Future<void> addOrder(List<CartItem> cart, double price) {
    final order = Order(
      cart: cart,
      price: price,
      id: DateTime.now().toString(),
      dateTime: DateTime.now(),
    );

    return http.post('$_dburl.json', body: _toJson(order)).then((res) {
      _orders.insert(
        0,
        Order(
          id: json.decode(res.body)['name'],
          cart: cart,
          price: price,
          dateTime: order.dateTime,
        ),
      );
      notifyListeners();
    });
  }

  Future<void> refreshOrders(){
    return http.get('$_dburl.json').then((res){
      print(json.decode(res.body));
    });
  }

  Future<void> fetchAndSetOrders(){
    if(_orders.length > 0){
      return refreshOrders();
    }
    return Future.delayed(Duration.zero);
  }
}