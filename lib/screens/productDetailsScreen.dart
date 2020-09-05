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
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageURL,
                fit: BoxFit.cover,
              ),
            ),
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
            SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }
}
