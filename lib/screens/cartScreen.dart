import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';
import '../models/cart.dart';
import '../widgets/cartItem.dart' as CI;
// 'as CI' is like a nickname and can be used as a prefix

// The name 'CartItem' is defined in the libraries 'package:shoppingApp/models/cart.dart' and
// 'package:shoppingApp/widgets/cartItem.dart'.
// Try using 'as prefix' for one of the import directives, or hiding the name from all but one of the imports.

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1.toString(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  /* SizedBox(
                    width: 15,
                  ), */
                  Spacer(),
                  Chip(
                    // 'Chip()' -> In-built widget
                    label: Text(
                      // cart.totalCost.toString(),
                      "₹${cart.totalCost}",
                      style: TextStyle(
                        // fontStyle: FontStyle.italic,
                        fontSize: 20,
                        color:
                            Theme.of(context).primaryTextTheme.bodyText1.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  /*  SizedBox(
                    width: 10,
                  ), */
                  FlatButton(
                    child: Text(
                      "Place Order",
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.toString(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Colors.purple,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalCost,
                      );
                      cart.clearCart();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (contxt, index) => CI.CartItem(
                // Since 'CartItem()' class name is used in both 'cart.dart' and 'cartItem.dart'
                // ambiguity occurs
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                // '.values' returns a iterable, so it needs to be converted to a list
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
