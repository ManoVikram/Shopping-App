import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItems order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 400,
      ),
      curve: Curves.easeIn,
      height: _expanded
          ? min(200.0, widget.order.products.length * 30.0 + 150.0)
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("₹${widget.order.totalAmount}"),
              subtitle: Text(
                DateFormat.yMMMd().add_jm().format(
                      widget.order.orderDate,
                    ),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            // if (_expanded)
            AnimatedContainer(
              /* constraints: BoxConstraints(
                minHeight: _expanded
                    ? min(200.0, widget.order.products.length * 30.0 + 10.0)
                    : 0,
                maxHeight: _expanded
                    ? max(100.0, widget.order.products.length * 30.0 + 10.0)
                    : 0,
              ), */
              duration: Duration(
                milliseconds: 400,
              ),
              curve: Curves.easeIn,
              height: _expanded
                  ? min(100.0, widget.order.products.length * 30.0 + 10.0)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .toString(),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "${product.quantity} x ₹${product.price}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
