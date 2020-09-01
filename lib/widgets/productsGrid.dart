import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './productItem.dart';
import '../providers/productsProvider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    // Listener
    final products = productData.items;
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
      itemBuilder: (contxt, index) => ChangeNotifierProvider(
        create: (contxt) => products[index],
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
