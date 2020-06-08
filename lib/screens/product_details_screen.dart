import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';
  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context).settings.arguments;
    final Product product = Provider.of<Products>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            "Rs. ${product.price}",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
          Text(product.description),
        ],
      ),
    );
  }
}
