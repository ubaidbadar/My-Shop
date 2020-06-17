import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import '../providers/cart.dart' as ci;
import './orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<ci.Cart>(context);
    final addOrder = Provider.of<Orders>(context, listen: false).addOrder;
    void addingOrder(){
      addOrder(cart.cart, cart.totalPrice);
      cart.clearCart();
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: cart.length < 1
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: cart.length < 1
              ? <Widget>[
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Your Cart is Empty',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    alignment: Alignment.center,
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Start Adding Products',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ]
              : <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total Price',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(),
                          ),
                          Chip(
                            backgroundColor: Theme.of(context).accentColor,
                            label: Text(
                              'Rs ${cart.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          FlatButton(
                            child: Text(
                              'ORDER NOW',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: addingOrder,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (_, i) => CartItem(cart.cart[i]),
                      itemCount: cart.cart.length,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
