import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/products.dart';
import '../models/httpException.dart';

class ProductsProvider
    with
        ChangeNotifier /* 'with ClassName' - Mixins - merge some properties to the existing class(like inheritance) */ {
  // 'ChangeNotifier' - More like 'inherited' widget
  List<Product> _items = [
    /* Product(
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
    ), */
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
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);
  // '_items' is also initialized.
  // Because, data might get lost during the re-build.

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

  Future<void> fetchProducts([bool filterByUser = false]) async {
    // Arguments inside [] are default arguments.
    final filterString =
        filterByUser ? 'orderBy="productCreatorId"&equalTo="$userId"' : '';
    print(filterByUser ? "1=" : "0=");
    var url =
        "https://shopping-app-f0bc8.firebaseio.com/products.json?auth=$authToken&$filterString";
    print(url);
    // '?auth=[TOKEN]' needs to be set to tell firebase that the user is authenticated.
    // "orderBy='productCreatorId'&equalTo='$userId'" - Filter and return the procucts
    // where 'productCreatorId' is equal to 'userId'
    // 'orderBy' and 'equalTo' are Firebase specific terms.
    /* Only 'userProductsScreen' needs filtering */

    /*
    "products": {
      ".indexOn": ["productCreatorId"],
    }
    The above code needs to be added to the Firebase Realtime Database Rules
    */

    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // Dart couldn't understand that the value is a 'Map'/'Object'. So, 'dynamic' is used.

      if (extractedData == null) {
        return;
      }

      url =
          "https://shopping-app-f0bc8.firebaseio.com/userFavourites/$userId.json?auth=$authToken";
      final favouriteResponse = await http.get(url);
      // Gets all the favourites of that particular user.
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedItems = [];
      extractedData.forEach(
        (productIdKey, productDataValue) {
          loadedItems.add(
            Product(
              id: productIdKey,
              title: productDataValue["title"],
              description: productDataValue["description"],
              imageURL: productDataValue["imageURL"],
              price: productDataValue["price"],
              // isFavourite: productDataValue["isFavourite"],
              isFavourite: favouriteData == null
                  ? false
                  : favouriteData[productIdKey] ?? false,
              // 'favouriteData[productIdKey] ?? false' - When favouriteData[productIdKey] isn't
              // available(== null), false is set.
            ),
          );
        },
      );
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw error;
    }
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
    final url =
        "https://shopping-app-f0bc8.firebaseio.com/products.json?auth=$authToken";
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
            "productCreatorId": userId,
            // "isFavourite": product.isFavourite,
            // Favourites data is managed separately on the server; respective to the user.
          },
        ),
        // 'body: ' contains JSON data, use "import 'dart:convert';"
      );
      print("Hello");
      print(json
          .decode(response.body)["name"]); // unique id provided by the backend
      print("World");
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

  Future<void> updateProduct(String productId, Product updatedProduct) async {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    if (productIndex >= 0) {
      final url =
          "https://shopping-app-f0bc8.firebaseio.com/products/$productId.json?auth=$authToken";
      // All 'http' requests should be present inside 'async' method with return type as 'Future'
      await http.patch(
        url,
        body: json.encode(
          {
            "title": updatedProduct.title,
            "description": updatedProduct.description,
            "imageURL": updatedProduct.imageURL,
            "price": updatedProduct.price,
            // Firebase won't erase 'productCreatorId' as it is not updated/erased.
            // 'productCreatorId' value will remain the same.
            // It will automatically add new keys(if any)
            // Else, values of current keys will be updated on the Firebase.
          },
        ),
      );
      _items[productIndex] = updatedProduct;
    }
    notifyListeners();
  }

  /* void removeProduct(String id) {
    final url = "https://shopping-app-f0bc8.firebaseio.com/products/$id.json";
    final currentProductIndex =
        _items.indexWhere((product) => product.id == id);
    var currentProduct = _items[currentProductIndex];

    _items.removeAt(currentProductIndex);
    notifyListeners();
    http.delete(url).then(
      // '.delete()' doesn't throw an error even if an error status code is thrown from the server.
      (response) {
        print(response.statusCode);
        if (response.statusCode >= 400) {
          // throw Exception(); - Discouraged by the Dart team. Use own exceptions.
          throw HttpException("Error occurred!! Couldn't delete product.");
        }
        currentProduct = null;
      },
    ).catchError(
      (_) {
        _items.insert(currentProductIndex, currentProduct);
        notifyListeners();
      },
    );
    // _items.removeWhere((product) => product.id == id);
  } */

  Future<void> removeProduct(String id) async {
    final url =
        "https://shopping-app-f0bc8.firebaseio.com/products/$id.json?auth=$authToken";
    final currentProductIndex =
        _items.indexWhere((product) => product.id == id);
    var currentProduct = _items[currentProductIndex];

    _items.removeAt(currentProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    // '.delete()' doesn't throw an error even if an error status code is thrown from the server.
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(currentProductIndex, currentProduct);
      notifyListeners();
      // throw Exception(); - Discouraged by the Dart team. Use own exceptions.
      // 'throw' is like 'return'. It cancels the rest of the code execution.
      throw HttpException("Error occurred!! Couldn't delete product.");
    }
    currentProduct = null;

    // _items.removeWhere((product) => product.id == id);
  }
}
