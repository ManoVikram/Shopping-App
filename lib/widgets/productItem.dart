import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/productDetailsScreen.dart';
import '../models/products.dart';

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

    return Consumer<Product>(
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
              onPressed: product.toggleFavourite,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
