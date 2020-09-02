import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/productsOverviewScreen.dart';
import './screens/productDetailsScreen.dart';
import './providers/productsProvider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provider

      // A class needs to be provided above the classes that uses the data in the providers to access the data.
      // Here 'MyApp' is above 'ProductsOverview' and 'ProductDetails'
      // So, 'ChangeNotifierProvider' is specified here.

      // Only the listening widgets will be rebuilt.
      create: (contxt) => ProductsProvider(), // One instance for all
      // 'ChangeNotifierProvider.value()' isn't efficient when instantiating a Widget/Class - might cause bugs
      child: MaterialApp(
        title: "Shopping App",
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.amber,
          fontFamily: "Cinzel Decorative",
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  fontFamily: "Cantarell",
                  fontSize: 22,
                ),
              ),
        ),
        home: ShoppingApp(),
        routes: {
          ProductDetails.routeName: (contxt) => ProductDetails(),
        },
      ),
    );
  }
}

class ShoppingApp extends StatefulWidget {
  @override
  _ShoppingAppState createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          "Shopping",
        ),
      ), */
      body: ProductsOverview(),
    );
  }
}

void main() => runApp(MyApp());