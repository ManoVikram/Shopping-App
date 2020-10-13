import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/productsOverviewScreen.dart';
import './screens/productDetailsScreen.dart';
import './screens/cartScreen.dart';
import './screens/ordersScreen.dart';
import './screens/userProductsScreen.dart';
import './screens/addEditUserProducts.dart';
import './screens/authScreen.dart';
import './screens/splashScreen.dart';
import './providers/productsProvider.dart';
import './models/cart.dart';
import './models/orders.dart';
import './models/auth.dart';
import './helpers/customRouteTransition.dart';

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
          create: (contxt) => Auth(),
        ), // One instance for all
        // 'ChangeNotifierProvider.value(builder:)' isn't efficient when instantiating a Widget/Class - might cause bugs

        // 'ChangeNotifierProxyProvider<>()' is used when arguments needs to be passed.
        // 'ChangeNotifierProxyProvider<>()' allows to set up a provider which itself depends on another provider
        // defined before it.
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (contxt, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: null,
          // 'previousProducts' is the 3rd argument.
          // It holds the previous state/previous product.
        ),
        ChangeNotifierProvider(
          create: (contxt) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (contxt, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: null,
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
          // 'pageTransitionsTheme' is used to apply custom page transition to all the screens.
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageRouteTransitionBuilder(),
              TargetPlatform.iOS: CustomPageRouteTransitionBuilder(),
            },
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
    return Consumer<Auth>(
      builder: (contxt, auth, child) => Scaffold(
        /* appBar: AppBar(
          title: Text(
            "Shopping",
          ),
        ), */
        // body: ProductsOverview(),
        body: auth.isAuth
            ? ProductsOverview()
            : FutureBuilder(
                future: auth.tryAutoLogIn(),
                builder: (contxt, authResultSnapShot) =>
                    authResultSnapShot.connectionState ==
                            ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
      ),
    );
  }
}

void main() => runApp(MyApp());
