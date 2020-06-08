import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/spinner.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.removeListener(() {});
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  bool _initState = true;
  bool isEditMode = false;
  Products productData;

  Product editProduct = Product(
    id: DateTime.now().toString(),
    price: 0,
    title: '',
    imageUrl: '',
    description: '',
  );

  @override
  void didChangeDependencies() {
    if (_initState) {
      _initState = false;
      productData = Provider.of<Products>(context, listen: false);
      final String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        editProduct = productData.findById(productId);
        _imageUrlController.text = editProduct.imageUrl;
        isEditMode = true;
      }
    }
    super.didChangeDependencies();
  }

  bool _isSpinner = false;
  void _onSubmit() {
    bool isValid = _form.currentState.validate();
    if (!isValid) return;
    setState(() => _isSpinner = true);
    _form.currentState.save();
    isEditMode
        ? productData.updateProduct(editProduct)
        : productData
            .addProduct(editProduct)
            .then(_afterStoredProduct)
            .catchError(_onError);
  }

  void _afterStoredProduct(_) {
    setState(() => _isSpinner = false);
    Navigator.of(context).pop();
  }

  void _onError(err) {
    setState(() => _isSpinner = false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(err.toString()),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Product' : 'Add Product',
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _onSubmit)
        ],
      ),
      body: _isSpinner
          ? Spinner
          : Form(
              key: _form,
              child: Card(
                margin: const EdgeInsets.all(8),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) => value.trim().length < 3
                          ? "Title must be at least 3 characters long"
                          : null,
                      initialValue: editProduct.title,
                      onSaved: (value) {
                        editProduct = Product(
                          id: editProduct.id,
                          title: value,
                          price: editProduct.price,
                          imageUrl: editProduct.imageUrl,
                          description: editProduct.description,
                        );
                      },
                    ),
                    TextFormField(
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_descFocusNode),
                      validator: (value) => value.trim().length < 2 ||
                              double.tryParse(value) == null
                          ? 'Price must be at least 10'
                          : null,
                      onSaved: (value) {
                        editProduct = Product(
                          id: editProduct.id,
                          title: editProduct.title,
                          price: double.parse(value.trim()),
                          imageUrl: editProduct.imageUrl,
                          description: editProduct.description,
                        );
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Price'),
                      focusNode: _priceFocusNode,
                      initialValue:
                          isEditMode ? editProduct.price.toString() : '',
                    ),
                    TextFormField(
                      validator: (value) => value.trim().length < 10
                          ? "Description must be at least 10 characters long"
                          : null,
                      onSaved: (value) {
                        editProduct = Product(
                          id: editProduct.id,
                          title: editProduct.title,
                          price: editProduct.price,
                          imageUrl: editProduct.imageUrl,
                          description: value,
                        );
                      },
                      maxLines: 3,
                      focusNode: _descFocusNode,
                      initialValue: editProduct.description,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          child: _imageUrlController.text == ""
                              ? Text('Enter Image URL')
                              : Image.network(_imageUrlController.text,
                                  fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _onSubmit,
                            onSaved: (value) {
                              editProduct = Product(
                                id: editProduct.id,
                                title: editProduct.title,
                                price: editProduct.price,
                                description: editProduct.description,
                                imageUrl: value,
                              );
                            },
                            validator: (value) {
                              String urlPattern =
                                  r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                              final isValid =
                                  new RegExp(urlPattern, caseSensitive: false)
                                      .firstMatch(value);
                              return isValid == null
                                  ? "Please provide a valid image url"
                                  : null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
