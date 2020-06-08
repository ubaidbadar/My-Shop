import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' as c;

class CartItem extends StatelessWidget {
  final c.CartItem _cartItem;
  const CartItem(this._cartItem);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<c.Cart>(context, listen: false);
    Future<bool> boforeDissmiss(_) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Are you sure?'),
          content:
              Text('Do you want to remove "${_cartItem.title}" from the cart?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      );
    }

    return Dismissible(
      onDismissed: (_) => cart.removeFromCart(_cartItem.id),
      confirmDismiss: boforeDissmiss,
      direction: DismissDirection.endToStart,
      key: ValueKey(_cartItem.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 36,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
      ),
      child: Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 28,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${_cartItem.price}"),
              ),
            ),
          ),
          title: Text(_cartItem.title),
          subtitle: Text("Rs. ${_cartItem.price * _cartItem.quantity}"),
          trailing: Text("${_cartItem.quantity}x"),
        ),
      ),
    );
  }
}
