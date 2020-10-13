import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/ordersScreen.dart';
import '../screens/userProductsScreen.dart';
import '../models/auth.dart';
import '../helpers/customRouteTransition.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              "Hello buddy!",
              style: TextStyle(
                color: Colors.white,
                fontFamily: Theme.of(context).textTheme.bodyText1.toString(),
                fontWeight: FontWeight.bold,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              "My Orders",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              /* Navigator.of(context).pushReplacement(
                CustomRouteTransition(
                  builder: (contxt) => OrdersScreen(),
                ),
              );
              // Custom animation is used only when moved to Orders screen. */
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text(
              "My Products",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "Log Out",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              /* Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName); */
              Navigator.of(context).pop(); // Closes the AppDrawer
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
