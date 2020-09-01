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
    );
  }
}
