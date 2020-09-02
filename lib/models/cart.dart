import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quaintity;

  CartItem({
    @required this.id, // Different from the 'id' of the Product
    @required this.title,
    @required this.price,
    @required this.quaintity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {}; // maps 'productId' with the 'CartItem'

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get numberOfCartItems {
    int val = 0;
    items.forEach((key, value) {
      val += value.quaintity;
    });
    return val;
  }

  void addCartItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (productIdItem) => CartItem(
          id: productIdItem.id,
          title: productIdItem.title,
          price: productIdItem.price,
          quaintity: productIdItem.quaintity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quaintity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
