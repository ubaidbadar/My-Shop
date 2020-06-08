import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: orders.length > 0
          ? ListView.builder(
              itemBuilder: (_, i) => OrderItem(orders[i]),
              padding: const EdgeInsets.all(8),
              itemCount: orders.length,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text(
                    "You havn't placed any order yet",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  alignment: Alignment.center,
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Start Buying Products',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/'),
                ),
              ],
            ),
    );
  }
}
