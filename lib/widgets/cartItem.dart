import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.only(
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete_sweep,
          size: 40,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        padding: EdgeInsets.only(
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        color: Colors.yellow,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.remove_circle,
          size: 40,
          color: Colors.white,
        ),
      ),
      // direction: DismissDirection.startToEnd,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "₹$price",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: ${(quantity * price)}"),
            trailing: Text("x $quantity"),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        bool decision = false;
        if (direction == DismissDirection.startToEnd) {
          // decision = true;
          return showDialog(
            context: context,
            builder: (contxt) => AlertDialog(
              title: Text(
                "Are you sure?",
              ),
              content: Text(
                "Do you want to remove the item?",
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    decision = true;
                    Navigator.of(context).pop(decision);
                  },
                  child: Text(
                    "Yes",
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    decision = false;
                    Navigator.of(context).pop(decision);
                  },
                  child: Text(
                    "No",
                  ),
                ),
              ],
            ),
          );
        } else if (direction == DismissDirection.endToStart) {
          // TODO: Decrease the quantity of the product(function call - function in cart.dart)
          return showDialog(
            context: context,
            builder: (contxt) => AlertDialog(
              title: Text(
                "Are you sure?",
              ),
              content: Text(
                "Do you want to reduce the quantity of the item?",
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    decision = false;
                    Navigator.of(context).pop(decision);
                    Provider.of<Cart>(context, listen: false)
                        .reduceQuantity(productId);
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "$title quantity decreased",
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Yes",
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    decision = false;
                    Navigator.of(context).pop(decision);
                  },
                  child: Text(
                    "No",
                  ),
                ),
              ],
            ),
          );
          // decision = false;
        }
        // return Future.value(decision);
        // return decision;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          Provider.of<Cart>(context, listen: false).removeCartItem(productId);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("$title removed")));
        }
      },
    );
  }
}
