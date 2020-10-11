import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        "https://shopping-app-f0bc8.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    print(json.decode(response.body));

    extractedData.forEach(
      (orderIdKey, orderDataValue) {
        loadedOrders.add(
          OrderItems(
            id: orderIdKey,
            products: (orderDataValue["products"] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item["id"],
                    title: item["title"],
                    price: item["price"],
                    quantity: item["quantity"],
                  ),
                )
                .toList()
                .reversed
                .toList(),
            totalAmount: orderDataValue["totalAmount"],
            orderDate: DateTime.parse(orderDataValue["orderDate"]),
            // '.toIso8601String()' helps in this parsing.
          ),
        );
      },
    );
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shopping-app-f0bc8.firebaseio.com/orders/$userId.json?auth=$authToken";
    final dateTimeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          "products": cartProducts
              .map(
                (product) => {
                  "id": product.id,
                  "title": product.title,
                  "price": product.price,
                  "quantity": product.quantity,
                },
              )
              .toList(),

          "totalAmount": total,
          "orderDate": dateTimeStamp.toIso8601String(),
          // '.toIso8601String()' converts the DateTime object to a string that is easily understandable and can be easily reconverted to a DateTime object.
        },
      ),
    );
    _orders.insert(
      0,
      OrderItems(
        id: json.decode(response.body)["name"],
        products: cartProducts,
        totalAmount: total,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
