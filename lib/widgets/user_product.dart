import 'package:flutter/material.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProduct extends StatelessWidget {
  final Product _product;
  const UserProduct(this._product);
  @override
  Widget build(BuildContext context) {
    void removeProduct() {
      Navigator.of(context).pop();
      Provider.of<Products>(context, listen: false).removerProduct(_product.id).catchError((err){
        final sf = Scaffold.of(context);
        sf.hideCurrentSnackBar();
        sf.showSnackBar(
          SnackBar(
            content: Text('Something went wrong!'),
            backgroundColor: Theme.of(context).errorColor,
          )
        );
      });
    }

    void beforeRemoveProduct() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Do you really want to remove this product'),
          title: Text('Are you sure?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes',
                  style: TextStyle(color: Theme.of(context).errorColor)),
              onPressed: removeProduct,
            ),
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(_product.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_product.imageUrl),
          radius: 24,
        ),
        subtitle: Text(_product.price.toString()),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.grey,
                onPressed: () => Navigator.pushNamed(
                  context,
                  EditProductScreen.routeName,
                  arguments: _product.id,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: beforeRemoveProduct,
              )
            ],
          ),
        ),
      ),
    );
  }
}
