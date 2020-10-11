import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './addEditUserProducts.dart';
import '../providers/productsProvider.dart';
import '../widgets/appDrawer.dart';
import '../widgets/userProductsItem.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProducts";

  Future<void> _refreshProducts(BuildContext context) async {
    // Since, the function is outside the 'build' method, 'context' isn't available.
    // So, 'context' needs to be passed as an argument.
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    // The above 'Provider' makes the program fall into the infinite loop.
    // Because, '_refreshProducts' is called in the body, which leads to re-building the build method again and again.
    // Using 'Consumer<>()' is a better choice in this case.
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (contxt, dataSnapShot) =>
            dataSnapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (contxt, productsData, child) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          itemBuilder: (contxt, index) {
                            return Column(
                              children: [
                                UserProductsItem(
                                  productsData.items[index].id,
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
                    ),
                  ),
      ),
    );
  }
}
