import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/user_product.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-orders';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, EditProductScreen.routeName),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (_, i) => UserProduct(products[i]),
        itemCount: products.length,
      ),
    );
  }
}
