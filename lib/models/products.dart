import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageURL,
    @required this.price,
    this.isFavourite = false,
  });

  void _setFavouriteValue(bool value) {
    isFavourite = value;
    notifyListeners();
  }

  Future<void> toggleFavourite() async {
    final oldFavouriteStatus = isFavourite;
    final url = "https://shopping-app-f0bc8.firebaseio.com/products/$id.json";

    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.patch(
        // Unlike .get() and .post(), .patch() doesn't throw error.
        url,
        body: json.encode(
          {
            "isFavourite": isFavourite,
          },
        ),
      );

      if (response.statusCode >= 400) {
        /* isFavourite = oldFavouriteStatus;
        notifyListeners(); */
        _setFavouriteValue(oldFavouriteStatus);
      }
    } catch (error) {
      /* isFavourite = oldFavouriteStatus;
      notifyListeners(); */
      _setFavouriteValue(oldFavouriteStatus);
    }
  }
}
