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
          "My Cart",
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
                      "₹${cart.totalCost.toStringAsFixed(2)}",
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
                  PlaceOrderButton(cart: cart),
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

class PlaceOrderButton extends StatefulWidget {
  // 'setState()' is used inside the 'FlatButton'
  // 'setState()' rebuilds the 'build' method
  // To reduce the number of lines that gets rebuilt,
  // 'FlatButton()' is extracted to a separate widget.
  const PlaceOrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "Place Order",
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText1.toString(),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: Colors.purple,
                color: Theme.of(context).primaryColor,
              ),
            ),
      onPressed: (widget.cart.totalCost <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalCost,
              );

              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
    );
  }
}
