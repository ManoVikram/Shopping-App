import 'package:flutter/material.dart';

import '../widgets/productsGrid.dart';

class ProductsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ProductsGrid(),
    );
  }
}
