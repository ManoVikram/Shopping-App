import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingApp/models/orders.dart';

import './screens/productsOverviewScreen.dart';
import './screens/productDetailsScreen.dart';
import './screens/cartScreen.dart';
import './screens/ordersScreen.dart';
import './providers/productsProvider.dart';
import './models/cart.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 'MultiProvider()' is used for handling multiple 'ChangeNotifierProvider()'
      // ChangeNotifierProvider(create: () {}, child: ChangeNotifierProvider(create: () {}, child: ...,),), => Can also be used, but might look ugly.
      providers: [
        ChangeNotifierProvider(
          // Provider

          // A class needs to be provided above the classes that uses the data in the providers to access the data.
          // Here 'MyApp' is above 'ProductsOverview' and 'ProductDetails'
          // So, 'ChangeNotifierProvider' is specified here.

          // Only the listening widgets will be rebuilt.
          create: (contxt) => ProductsProvider(),
        ), // One instance for all
        // 'ChangeNotifierProvider.value()' isn't efficient when instantiating a Widget/Class - might cause bugs
        ChangeNotifierProvider(
          create: (contxt) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (contxt) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: "Shopping App",
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          fontFamily: "Cinzel Decorative",
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  fontFamily: "Cantarell",
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
        ),
        home: ShoppingApp(),
        routes: {
          ProductDetails.routeName: (contxt) => ProductDetails(),
          CartScreen.routeName: (contxt) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
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
