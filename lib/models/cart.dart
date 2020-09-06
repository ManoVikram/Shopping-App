import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id, // Different from the 'id' of the Product
    @required this.title,
    @required this.price,
    @required this.quantity,
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
      val += value.quantity;
    });
    return val;
  }

  double get totalCost {
    double cost = 0;
    _items.forEach((key, value) {
      cost += value.price * value.quantity;
    });
    return cost;
  }

  void addCartItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (productIdItem) => CartItem(
          id: productIdItem.id,
          title: productIdItem.title,
          price: productIdItem.price,
          quantity: productIdItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeCartItem(String productIdKey) {
    _items.remove(productIdKey);
    notifyListeners();
  }

  void reduceQuantity(String productIdKey) {
    if (!_items.containsKey(productIdKey)) {
      return;
    }

    if (_items[productIdKey].quantity > 1) {
      _items.update(
        productIdKey,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity - 1 <= 1 ? 1 : value.quantity - 1,
        ),
      );
    } else {
      removeCartItem(productIdKey);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
