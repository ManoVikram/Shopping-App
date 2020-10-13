import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/productsProvider.dart';

class ProductDetails extends StatelessWidget {
  // final String title;

  // ProductDetails(this.title);

  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    /* final loadedProduct =
        Provider.of<ProductsProvider>(context).items.firstWhere(
              (product) => product.id == productId,
            ); */
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false, // default is 'true'
      // Gets the data only once and does nothing later even if the data changes
    ).findById(
      productId,
    );
    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          loadedProduct.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ), */
      body: CustomScrollView(
        // 'slivers' - Parts of the screen that can scroll.
        slivers: [
          // 'SliverAppBar()' dynamically changes into an AppBar
          SliverAppBar(
            expandedHeight: 300,
            // Actually, represents the height of the image.
            pinned: true,
            // 'AppBar' sticks to the top when scrolled.
            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,
              title: Text(
                loadedProduct.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                // textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: loadedProduct.id,
                // 'tag:' value should be same on both the screens.
                // Here, in 'productDetailsScreen.dart' and 'productItem.dart'
                child: Image.network(
                  loadedProduct.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 'SliverList()' is a kind of list view with slivers(multiple scrollable things on the screen).
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Chip(
                  elevation: 5,
                  label: Text(
                    "₹${loadedProduct.price}",
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1.toStringShort(),
                      color: Colors.blueGrey[600],
                      shadows: [
                        /* Shadow(
                      offset: Offset(5, 5),
                      blurRadius: 5,
                      color: Colors.black87,
                    ), */
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.white,
                ),
                Column(
                  // Column() isn't actually necessary.
                  // Here, Column() is used to align things to center(especially product description).
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      // width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Text(
                        loadedProduct.description,
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.toString(),
                          letterSpacing: 3,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 1000,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        /* body: SingleChildScrollView(
         child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: /* Hero(
                tag: loadedProduct.id,
                // 'tag:' value should be same on both the screens.
                // Here, in 'productDetailsScreen.dart' and 'productItem.dart'
                child: Image.network(
                  loadedProduct.imageURL,
                  fit: BoxFit.cover,
                ),
              ), */ // Used inside SliverAppBar()
            ),
            /* SizedBox(
              height: 10,
            ),
            Chip(
              elevation: 5,
              label: Text(
                "₹${loadedProduct.price}",
                style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.bodyText1.toStringShort(),
                  color: Colors.blueGrey[600],
                  shadows: [
                    /* Shadow(
                      offset: Offset(5, 5),
                      blurRadius: 5,
                      color: Colors.black87,
                    ), */
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.white,
            ), */ // Used in SliverList()
            /* SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                loadedProduct.description,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.bodyText1.toString(),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.justify,
              ),
            ), */ // Used inside SliverList()
          ],
        ), */
      ),
    );
  }
}
