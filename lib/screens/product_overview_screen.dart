import 'package:flutter/material.dart';
import 'package:myshop/widgets/spinner.dart';
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
  bool _init = true;
  Products _products;
  bool _spinner = false;
  bool _showErr = false;
  @override
  void didChangeDependencies() {
    if (_init) {
      _init = false;
      _spinner = true;
      getProducts();
    }
    super.didChangeDependencies();
  }

  void getProducts() {
    if (!_spinner) {
      setState(() => _spinner = true);
    }
    _products = Provider.of<Products>(context);
    _products
        .fetchAndSetProducts()
        .then((_) => setState(() => _spinner = false))
        .catchError((err) {
      setState(() {
        _spinner = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text("$err"),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartlength = Provider.of<Cart>(context).length;
    final List<Product> products = _filter == FavOptions.Favorites
        ? _products.products.where((p) => p.isFavorite).toList()
        : _products.products;
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
      body: !_showErr
          ? (_spinner
              ? Spinner()
              : (products.length > 0
                  ? GridView.builder(
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
                    )
                  : Center(
                      child: Text(
                        'Products not found!',
                        style: TextStyle(fontSize: 20),
                      ),
                    )))
          : Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }
}
