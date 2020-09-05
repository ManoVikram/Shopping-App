import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItems {
  final String id;
  final List<CartItem> products;
  final double totalAmount;
  final DateTime orderDate;

  OrderItems({
    @required this.id,
    @required this.products,
    @required this.totalAmount,
    @required this.orderDate,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        products: cartProducts,
        totalAmount: total,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
