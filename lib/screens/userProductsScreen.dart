import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './addEditUserProducts.dart';
import '../providers/productsProvider.dart';
import '../widgets/appDrawer.dart';
import '../widgets/userProductsItem.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProducts";
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddEditUserProductsScreen.routeName,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemBuilder: (contxt, index) {
            return Column(
              children: [
                UserProductsItem(
                  productsData.items[index].title,
                  productsData.items[index].imageURL,
                ),
                Divider(),
              ],
            );
          },
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
