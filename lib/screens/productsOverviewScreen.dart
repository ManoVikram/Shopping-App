import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/productsGrid.dart';
import '../widgets/badge.dart';
import '../providers/productsProvider.dart';
import '../models/cart.dart';
import '../screens/cartScreen.dart';

enum PopupMenuIndex {
  WishList,
  ShowAll,
}

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showFavourites = false;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (contxt) => [
              PopupMenuItem(
                child: Text("Wish List"),
                value: PopupMenuIndex
                    .WishList, // Index can also be directly specifies - 0
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: PopupMenuIndex
                    .ShowAll, // Index can also be directly specifies - 1
              ),
            ],
            onSelected: (PopupMenuIndex value) {
              setState(() {
                if (value == PopupMenuIndex.WishList) {
                  /* productData.showFavouritesOnly(); */
                  // Turning this 'Stateless' widget to 'Stateful' widget is a better option, istead of using 'Providers' in this case
                  _showFavourites = true;
                } else {
                  /* productData.showAll(); */
                  _showFavourites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            // 'Provider.of<Cart>(context)' makes the entire build method to run as it needs to be defined before 'return'
            // 'Consumer<Cart>()' rebuilds only the required data
            builder: (contxt, cart, childArg) {
              return Badge(
                value: cart.numberOfCartItems.toString(),
                child: childArg, // Data in 'childArg' will not be re-buit
                color: null,
              );
            },
            // 'child' argument of 'Consumer<>()' will not be re-built
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showFavourites),
    );
  }
}
