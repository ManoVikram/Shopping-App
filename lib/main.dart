import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/productsOverviewScreen.dart';
import './screens/productDetailsScreen.dart';
import './screens/cartScreen.dart';
import './screens/ordersScreen.dart';
import './screens/userProductsScreen.dart';
import './screens/addEditUserProducts.dart';
import './screens/authScreen.dart';
import './providers/productsProvider.dart';
import './models/cart.dart';
import './models/orders.dart';
import './models/auth.dart';

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
        ChangeNotifierProvider(
          create: (contxt) => Auth(),
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
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          AddEditUserProductsScreen.routeName: (context) =>
              AddEditUserProductsScreen(),
          AuthScreen.routeName: (contxt) => AuthScreen(),
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
      // body: ProductsOverview(),
      body: AuthScreen(),
    );
  }
}

void main() => runApp(MyApp());
