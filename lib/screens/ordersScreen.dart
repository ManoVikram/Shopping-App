import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';
import '../widgets/orderItem.dart' as OrdItm;
import '../widgets/appDrawer.dart';

// 'import '../models/orders.dart' show Orders;' can also be used,
// this will import only the 'Orders' class form the file

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (contxt, index) =>
            OrdItm.OrderItem(ordersData.orders[index]),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}