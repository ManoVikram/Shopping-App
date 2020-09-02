import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/productsGrid.dart';
import '../providers/productsProvider.dart';

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
        ],
      ),
      body: ProductsGrid(_showFavourites),
    );
  }
}
