import 'package:flutter/material.dart';
import 'package:myshop/widgets/spinner.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    Widget errorHander(err) {
      return AlertDialog(
        title: Text('Error'),
        content: Text('$err'),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      );
    }

    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ordersData.refreshOrders,
        child: FutureBuilder(
            future: ordersData.fetchAndSetOrders(),
            builder: (_, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Spinner();
              }
              if (dataSnapShot.hasError) {
                return errorHander(dataSnapShot.error);
              }
              return ordersData.orders.length > 0
                  ? ListView.builder(
                      itemBuilder: (_, i) => OrderItem(ordersData.orders[i]),
                      padding: const EdgeInsets.all(8),
                      itemCount: ordersData.orders.length,
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
                    );
            }),
      ),
    );
  }
}
