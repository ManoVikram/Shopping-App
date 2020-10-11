import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';
import '../widgets/orderItem.dart' as OrdItm;
import '../widgets/appDrawer.dart';

// 'import '../models/orders.dart' show Orders;' can also be used,
// this will import only the 'Orders' class form the file

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

// ----- METHOD-1 -----
/* class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // 'Future.delayed(Duration.zero)' is executed only after all the initialization and 'build' method is run.
    // ===== METHOD-1 =====
    /* Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrders();
      setState(() {
        _isLoading = false;
      });
    }); */

    // ===== METHOD-2 ===== -> Can be used only when 'listen: false'
    _isLoading = true;

    Provider.of<Orders>(context, listen: false).fetchOrders().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (contxt, index) =>
                  OrdItm.OrderItem(ordersData.orders[index]),
              itemCount: ordersData.orders.length,
            ),
    );
  }
} */

// ----- METHOD-2 ----- | #RECOMMENDED
class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoading = false;
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
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
      body: FutureBuilder(
        builder: (contxt, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              // TODO: Error handling
              print(dataSnapshot.error);
              return Center(
                child: Text("An error occurred!!"),
              );
            } else {
              return Consumer<Orders>(
                builder: (contxt, ordersData, child) => ListView.builder(
                  itemBuilder: (contxt, index) =>
                      OrdItm.OrderItem(ordersData.orders[index]),
                  itemCount: ordersData.orders.length,
                ),
              );
            }
          }
        },
        future: _ordersFuture,
      ),
    );
  }
}
