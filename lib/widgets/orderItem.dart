import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/orders.dart';

class OrderItem extends StatelessWidget {
  final OrderItems order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${order.totalAmount}"),
            subtitle: Text(
              DateFormat.yMMMd().add_jm().format(
                    order.orderDate,
                  ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
