import 'package:flutter/material.dart';

class FavoriteProduct extends StatefulWidget {
  final Function favHanlder;
  final bool isFavorite;
  FavoriteProduct({@required this.favHanlder, @required this.isFavorite});
  @override
  _FavoriteProductState createState() => _FavoriteProductState();
}

class _FavoriteProductState extends State<FavoriteProduct> {
  bool _spinner = false;
  void _favHandler() {
    setState(() => _spinner = true);
    widget.favHanlder().then((_) => setState(() => _spinner = false));
  }

  @override
  Widget build(BuildContext context) {
    return _spinner
        ? Container(
            child: CircularProgressIndicator(strokeWidth: 4),
            height: 20,
            width: 20,
            margin: const EdgeInsets.symmetric(horizontal: 14),
          )
        : IconButton(
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: _favHandler,
          );
  }
}
