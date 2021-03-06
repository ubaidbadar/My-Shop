import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_details_screen.dart';
import '../widgets/favorite_product.dart';
import '../providers/products.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final sf = Scaffold.of(context);

    void removeProductFromCart() {
      cart.removeSingleCartItem(product.id);
      sf.hideCurrentSnackBar();
      sf.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Theme.of(context).errorColor,
        content: Text("${product.title} has been removed from cart!"),
      ));
    }

    void addToCart(Product product) {
      cart.addToCart(product);
      sf.removeCurrentSnackBar();
      sf.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        content: Text(
          "${product.title} is added to the cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Theme.of(context).errorColor,
          onPressed: removeProductFromCart,
        ),
      ));
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ProductDetailsScreen.routeName,
        arguments: product.id,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.fill,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(product.title),
            leading: Consumer<Product>(
              builder: (_, i, child) => FavoriteProduct(
                favHanlder: product.toggleFavoriteStatus,
                isFavorite: product.isFavorite,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () => addToCart(product),
            ),
          ),
        ),
      ),
    );
  }
}
