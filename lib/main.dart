import 'package:flutter/material.dart';

import './screens/productsOverviewScreen.dart';
import './screens/productDetailsScreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        ProductDetails.routeName: 
      },
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
