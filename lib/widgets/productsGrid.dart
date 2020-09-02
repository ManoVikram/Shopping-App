import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './productItem.dart';
import '../providers/productsProvider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavourites;

  ProductsGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    // Listener
    final products =
        showFavourites ? productData.favouriteItems : productData.items;
    // 'of()' is a generic type - so data type can be specified
    // Tells that thid widget is listening
    // Sets up a direct communication channel behind the screens
    // Gets rebuilt whenever the required data changes
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (contxt, index) => ChangeNotifierProvider.value(
        // 'ChangeNotifierProvider.value()' is recommended while traversing through a list of items that already exists
        // create: (contxt) => products[index],
        value: products[index],
        // Since '(contxt)' isn't actually used, we used 'ChangeNotifierProvider.value(value:)' to avoid 'context'
        // Works perfectly even if the data changes - Keeps up with the data change.
        // Should be used when the data is provided on single List/Grid items

        // 'ChangeNotifierProvider(create: (contxt) {})' can also be used
        // Malfunctioning occurs if the data changes - Doesn't keep up with the data change
        // Causes bugs
        child: ProductItem(
          id: products[index].id,
          title: products[index].title,
          imageURL: products[index].imageURL,
        ),
      ),
      itemCount: products.length,
    );
  }
}
