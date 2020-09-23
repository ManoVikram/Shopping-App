import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/products.dart';

class ProductsProvider
    with
        ChangeNotifier /* 'with ClassName' - Mixins - merge some properties to the existing class(like inheritance) */ {
  // 'ChangeNotifier' - More like 'inherited' widget
  List<Product> _items = [
    Product(
      id: "P1",
      title: "Adidas Shoes",
      description: "The best comfy shoes on the planet.",
      imageURL:
          "https://assets.adidas.com/images/w_385,h_385,f_auto,q_auto:sensitive,fl_lossy/842b5da3036849a7bce2ab7b000ce85d_9366/ultraboost-20-shoes.jpg",
      price: 2500,
    ),
    Product(
      id: "P2",
      title: "Basics T-Shirt",
      description: "Feel the air wearing it.",
      imageURL:
          "https://images-na.ssl-images-amazon.com/images/I/91lwo2JSKyL._UX466_.jpg",
      price: 749,
    ),
    Product(
      id: "P3",
      title: "Apple iPhone",
      description: "The smartphone you never imagined.",
      imageURL:
          "https://specials-images.forbesimg.com/imageserve/5eebf1a63f00c50007f33477/960x0.jpg?fit=scale",
      price: 99999,
    ),
    Product(
      id: "P4",
      title: "Mac Book",
      description: "The world is on your table.",
      imageURL:
          "https://5.imimg.com/data5/XI/KO/MY-16701245/apple-macbook-air-mqd32hn-a-13-3-inch-laptop-2017-core-i5-8-500x500.jpg",
      price: 69999,
    ),
  ];
  /* var _showFavouritesOnly = false;

  void showFavouritesOnly() {
    _showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavouritesOnly = false;
    notifyListeners();
  } */

  List<Product> get items {
    /*  if (_showFavouritesOnly) {
      return _items.where((productData) => productData.isFavourite).toList();
    } */
    // '[..._items]' - returns the copy of the '_items' list
    // 'return _items' - returns the reference(pointer to the object in memory) to the '_items' list,
    // which makes it accessible outside the class, gives direct access to '_items'
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((productItem) => productItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // ===== METHOD-1 =====
  /* Future<void> addProduct(Product product) {
    /* return type is made 'Future<void>', so that 'addProduct().then(() {})'
    can be used to have a loading indicator or wait on the form page till the
    data is added and response is received from the server. */
    const url = "https://shopping-app-f0bc8.firebaseio.com/products.json";
    // 'https://project-name.firebaseio.com/folder-name.json'
    // - '/folder-name.json' is just a Firebase requirement(mandatory), not for others.
    return http
        .post(
      url,
      body: json.encode(
        {
          "title": product.title,
          "description": product.description,
          "imageURL": product.imageURL,
          "price": product.price,
          "isFavourite": product.isFavourite,
        },
      ),
      // 'body: ' contains JSON data, use "import 'dart:convert';"
    )
        .then(
      // The code within will be executed only when the response is received from the backend/server or
      // all the 'asynchronous' (statements after, outside .then()/Future block).
      // '.then()' returns 'Future' => .then(() {}).then(() {}) is possible
      (response) {
        print(json.decode(
            response.body)["name"]); // unique id provided by the backend
        Product newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          imageURL: product.imageURL,
          price: product.price,
        );

        _items.add(newProduct);
        /* _items.insert(0, newProduct); // Adds the product to the top of the list */

        notifyListeners(); // used by 'Providers' package and
        // creates a link between this class and the widgets that are interested in this class and
        // listening to changes in this class.
      },
    ).catchError(
      (error) {
        print(error);
        throw error;
      },
    );
    // .then(() {}).catchError((error) {}) => '.catchError((error) {})' catches all the errors in the
    // Future and/or .then() before it.
    // '.catchError((error) {})' also returns 'Future'
    // .then(() {}).catchError((error) {}).then(() {}) is also possible.

    // return Future.value();
    // returns 'Future' with no value
    // Also, it is executed as it is 'asynchronous'.
    // 'Future' executes all the 'asynchronous' statements immediately.
  } */

  // ===== METHOD-2 =====
  Future<void> addProduct(Product product) async {
    // 'async' function always returns a 'Future'

    /* return type is made 'Future<void>', so that 'addProduct().then(() {})'
    can be used to have a loading indicator or wait on the form page till the
    data is added and response is received from the server. */
    const url = "https://shopping-app-f0bc8.firebaseio.com/products.json";
    // 'https://project-name.firebaseio.com/folder-name.json'
    // - '/folder-name.json' is just a Firebase requirement(mandatory), not for others.

    try {
      // 'await' tells Dart to wait till the current operation finish, before moving on to the next line/operation
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "imageURL": product.imageURL,
            "price": product.price,
            "isFavourite": product.isFavourite,
          },
        ),
        // 'body: ' contains JSON data, use "import 'dart:convert';"
      );
      print(json
          .decode(response.body)["name"]); // unique id provided by the backend
      final Product newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        imageURL: product.imageURL,
        price: product.price,
      );

      _items.add(newProduct);
      /* _items.insert(0, newProduct); // Adds the product to the top of the list */

      notifyListeners(); // used by 'Providers' package and
      // creates a link between this class and the widgets that are interested in this class and
      // listening to changes in this class.
    } catch (error) {
      print(error);
      throw error;
    }

    // The code within will be executed only when the response is received from the backend/server or
    // all the 'asynchronous' (statements after, outside .then()/Future block).
    // '.then()' returns 'Future' => .then(() {}).then(() {}) is possible

    // .then(() {}).catchError((error) {}) => '.catchError((error) {})' catches all the errors in the
    // Future and/or .then() before it.
    // '.catchError((error) {})' also returns 'Future'
    // .then(() {}).catchError((error) {}).then(() {}) is also possible.

    // return Future.value();
    // returns 'Future' with no value
    // Also, it is executed as it is 'asynchronous'.
    // 'Future' executes all the 'asynchronous' statements immediately.
  }

  void updateProduct(String productId, Product updatedProduct) {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    if (productIndex >= 0) {
      _items[productIndex] = updatedProduct;
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
