import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../providers/productsProvider.dart';

class AddEditUserProductsScreen extends StatefulWidget {
  static const routeName = "/add-edit-product";

  @override
  _AddEditUserProductsScreenState createState() =>
      _AddEditUserProductsScreenState();
}

class _AddEditUserProductsScreenState extends State<AddEditUserProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  final _imageURLcontroller = TextEditingController();
  // 'TextEditingController()' is not necessary in 'Form()'
  // It is used here, because, the 'Container' needs to access the image url before the form is submitted,
  // to show preview

  final _form = GlobalKey<FormState>();
  // 'GlobalKey<>()' is used only when we want to interact with any Widget.
  // Here, we want to interact with 'Form' widget to submit the data filled in the form.
  // It is of generic type.
  // Always slides into the state of the Widget.
  // Interacts with the state behind the 'Form' widget.

  Product _editProduct = Product(
    id: null,
    title: null,
    description: null,
    imageURL: null,
    price: null,
  );
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    // 'price' is a String, because, 'TextFormField' always returns a String.
    "imageURL": "",
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageURLFocusNode.addListener(_imagePreview);
    // ModalRoute.of(context).settings.arguments; -> This won't work in the 'initState()'
    // Receiving data from a routing action won't work here.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // 'didChangeDependencies()' runs multiple times.
    // '_isInit' is used to prevent the routing statement from running multiple times.
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      // No argument is passed when a new product is created.
      if (productId != null) {
        _editProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editProduct.title,
          "description": _editProduct.description,
          "price": _editProduct.price.toString(),
          // "imageURL": _editProduct.imageURL,
        };
        _imageURLcontroller.text = _editProduct.imageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_imagePreview);
    // All created listeners must be removed to avoid memory leak.
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLcontroller.dispose();
    // 'FocusNode', 'TextEditingController' must be disposed once used to avoid memory leaks
    super.dispose();
  }

  void _imagePreview() {
    if (!_imageURLFocusNode.hasFocus) {
      if ((!_imageURLcontroller.text.startsWith("http") &&
              !_imageURLcontroller.text.startsWith(
                  "https")) /*  ||
          (!_imageURLcontroller.text.endsWith("jpg") &&
              !_imageURLcontroller.text.endsWith("jpeg") &&
              !_imageURLcontroller.text.endsWith("png")) */
          ) {
        return;
      }
      setState(() {});
    }
  }

  // ===== METHOD-1 =====
  /* void _saveForm() {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();

      setState(() {
        _isLoading = true;
      });

      if (_editProduct.id != null) {
        // Newly added products don't have 'id'
        // Products that are already present in the list have 'id'
        Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
        // When a product gets updated, it is dropped from the 'favourites'
        // Because, 'isFavourite' is 'false' by default
        /* This happens because the app is tricked as if the old product is updated,
        but, acutally, a new product is created and placed at the place of an old product.
        with updated values */
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        // Page is popped immediately after the product is updated.
      } else {
        Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editProduct)
            .catchError(
          // Catches the error from the 'throw error' statement within the .catchError() inside 'addProduct()' definition
          (error) {
            return showDialog(
              context: context,
              builder: (contxt) => AlertDialog(
                title: Text("Error!!"),
                // content: Text(error.toString()), => Prints the error in a readable format - But might contain confidential information
                content: Text("Something went wrong."),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(contxt).pop();
                    },
                    child: Text("Okay!"),
                  ),
                ],
              ),
            );
          },
        ).then(
          (_) {
            // As per syntax, though it is 'Future<void>',
            // we have to accept an argument.
            // '_' doesn't hold any value.
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
            // Page is popped only after the response is received from the server.
          },
        );
      }
      // Navigator.of(context).pop();
      // Leaves the screen, once the product is successfully submitted
    }
  } */

  // ===== METHOD-2 =====
  Future<void> _saveForm() async {
    // Since, 'async' always returns 'Future', the return type of the function should also be 'Future<type>'
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();

      setState(() {
        _isLoading = true;
      });

      if (_editProduct.id != null) {
        // Newly added products don't have 'id'
        // Products that are already present in the list have 'id'
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
        // When a product gets updated, it is dropped from the 'favourites'
        // Because, 'isFavourite' is 'false' by default
        /* This happens because the app is tricked as if the old product is updated,
        but, acutally, a new product is created and placed at the place of an old product.
        with updated values */
        /* setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        // Page is popped immediately after the product is updated. */
      } else {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_editProduct);
        } catch (e) {
          await showDialog(
            context: context,
            builder: (contxt) => AlertDialog(
              title: Text("Error!!"),
              // content: Text(error.toString()), => Prints the error in a readable format - But might contain confidential information
              content: Text("Something went wrong."),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(contxt).pop();
                  },
                  child: Text("Okay!"),
                ),
              ],
            ),
          );
        }
        /* finally {
          // 'finally' block always run even if there is an error or not.
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
          // Page is popped only after the response is received from the server.
        } */
      }
      // Navigator.of(context).pop();
      // Leaves the screen, once the product is successfully submitted
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      // Page is popped immediately after the product is updated.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues["title"],
                      decoration: InputDecoration(
                        labelText: "Title",
                        errorStyle: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.toString(),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      // Shows 'next' icon on the bottom-right of the keyboard
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a title.";
                          // Any text is interpreted as error.
                        }
                        return null;
                        // 'null' is interpreted as no error.
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                        // When the button on the bottom-right corner of the keyboard('->|') is pressed,
                        // the focus changes to the field where the 'focusNode' is '_priceFocusNode'
                        // Here, to the 'Price' field.
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: value,
                          description: _editProduct.description,
                          imageURL: _editProduct.imageURL,
                          price: _editProduct.price,
                          isFavourite: _editProduct.isFavourite,
                          // if the product is to be updated and if it is in 'Favourites/WishList',
                          // then, adding 'isFavourite: _editProduct.isFavourite' will preserve the product in the favourite.
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["price"],
                      decoration: InputDecoration(
                        labelText: "Price",
                        errorStyle: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.toString(),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      // Shows 'next' icon on the bottom-right of the keyboard
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a valid number.";
                        }
                        if (double.tryParse(value) == null) {
                          // if  the string/literal cannot be converted into  int/double, 'null' is returned.
                          return "Please enter a valid number.";
                        }
                        if (double.parse(value) <= 0) {
                          return "Enter a value greater than 0.";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          imageURL: _editProduct.imageURL,
                          price: double.parse(value),
                          isFavourite: _editProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["description"],
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      // textInputAction: TextInputAction.next,
                      // Shows 'next' icon on the bottom-right of the keyboard
                      keyboardType: TextInputType.multiline,
                      // Since, the keyboard is of type 'multiline', focus can't be changed to the next field.
                      // Keyboard will have new line button, instead of next button.
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a description.";
                        }
                        if (value.length < 10) {
                          return "Enter a description with more than characters.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: value,
                          imageURL: _editProduct.imageURL,
                          price: _editProduct.price,
                          isFavourite: _editProduct.isFavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          child: _imageURLcontroller.text.isEmpty
                              ? Center(
                                  child: Text(
                                    "No image",
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(
                                    _imageURLcontroller.text,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // 'TextFormField()' takes as much width as it can and might causes error
                            // (when inside a 'Row()'/'Widgets with no height/width handlers') if not handled.
                            // Here, 'Expanded()' does the job.

                            /* initialValue: _initValues["imageURL"], */
                            // 'initialValue' and 'controller' can't be used together
                            decoration: InputDecoration(
                              labelText: "Image URL",
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLcontroller,
                            focusNode: _imageURLFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                setState(() {});
                                // Helps in clearing out the image of the old url
                                // and shows an empty box when the old url is removed
                                return "Please enter an image URL";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter a valid image URL";
                              }
                              /* if (!value.endsWith("jpg") &&
                                  !value.endsWith("jpeg") &&
                                  !value.endsWith("png")) {
                                return "Please enter an URL with png/jpg/jpeg image.";
                              } */
                              return null;
                            },
                            onFieldSubmitted: (value) => _saveForm,
                            onSaved: (value) {
                              _editProduct = Product(
                                id: _editProduct.id,
                                title: _editProduct.title,
                                description: _editProduct.description,
                                imageURL: value,
                                price: _editProduct.price,
                                isFavourite: _editProduct.isFavourite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
