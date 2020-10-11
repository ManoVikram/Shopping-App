import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/productDetailsScreen.dart';
import '../models/products.dart';
import '../models/cart.dart';
import '../models/auth.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  ProductItem({this.id, this.title, this.imageURL});

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context);
    // 'Consumer()' does the same as 'Provider.of<type>()'

    /* Reference: https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple */

    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return Consumer<Product>(
      // Consumer only rebuilds the widgets that are part of its builder,
      // Provider.of() on the other hand triggers a complete re-build (i.e. re-runs build()) of this widget's widget tree.
      builder: (contxt, product, child) => ClipRRect(
        // Used to clip Widgets that can't be clipped(like 'GridTile')
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            // Makes the image clickable
            onTap: () {
              // Adding routes on the go - usually bad for bigger apps
              /* Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (contxt) => ProductDetails(title),
                ),
              ); */

              // Named route
              Navigator.of(context).pushNamed(
                ProductDetails.routeName,
                arguments: product.id,
                // arguments: id,
              );
            },
            child: Image.network(
              // imageURL,
              product.imageURL,
              fit: BoxFit.fitHeight,
              width: double.infinity,
            ),
          ),
          /* footer: Container(
            padding: EdgeInsets.all(15),
            color: Colors.black54,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ), */
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              // title,
              product.title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: product.isFavourite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.pink[400],
                    )
                  : Icon(Icons.favorite_border),
              onPressed: () => product.toggleFavourite(
                auth.token,
                auth.userId,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                cart.addCartItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Item added to the cart!",
                      // textAlign: TextAlign.center,
                    ),
                    duration: Duration(
                      seconds: 2,
                    ),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.reduceQuantity(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
