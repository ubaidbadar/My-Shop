import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

enum FavOptions {
  Favorites,
  ShowAll,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  FavOptions _filter = FavOptions.ShowAll;

  @override
  Widget build(BuildContext context) {
    final prodsdata = Provider.of<Products>(context);
    final cartlength = Provider.of<Cart>(context).length;
    final List<Product> products = _filter == FavOptions.Favorites
        ? prodsdata.products.where((p) => p.isFavorite).toList()
        : prodsdata.products;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Badge(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
            value: cartlength,
          ),
          PopupMenuButton(
            onSelected: (FavOptions selectedValue) =>
                setState(() => _filter = selectedValue),
            icon: Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('Show All'),
                value: FavOptions.ShowAll,
              ),
              PopupMenuItem(
                child: Text('Favorites'),
                value: FavOptions.Favorites,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 16 / 15,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (_, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        ),
        itemCount: products.length,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
