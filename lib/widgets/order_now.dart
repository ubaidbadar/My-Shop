import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';

class OrderNow extends StatefulWidget {
  final List<CartItem> cart;
  final double totalPrice;
  final Function cleatCart;
  OrderNow({
    @required this.cart,
    @required this.totalPrice,
    @required this.cleatCart,
  });
  @override
  _OrderNowState createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  bool _spinner = false;

  @override
  Widget build(BuildContext context) {
    final addOrder = Provider.of<Orders>(context, listen: false).addOrder;
    void _addingOrder() {
      setState(() => _spinner = true);
      addOrder(widget.cart, widget.totalPrice).then((_) {
        widget.cleatCart();
        Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
      }).catchError((err) {
        AlertDialog(
          title: Text('Error'),
          content: Text('$err'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            )
          ],
        );
      });
    }

    return _spinner
        ? Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: CircularProgressIndicator(
              strokeWidth: 4,
            ),
          )
        : FlatButton(
            child: Text(
              'ORDER NOW',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            onPressed: _addingOrder,
          );
  }
}
