import 'package:flutter/material.dart';

import '../models/products.dart';
import '../widgets/productItem.dart';

class ProductsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> loadedProducts = [
      Product(
        id: "P1",
        title: "Adidas Shoes",
        description: "The best comfy shoes on the planet.",
        imageURL:
            "https://assets.adidas.com/images/w_385,h_385,f_auto,q_auto:sensitive,fl_lossy/842b5da3036849a7bce2ab7b000ce85d_9366/ultraboost-20-shoes.jpg",
        price: 2500,
      ),
      Product(
        id: "P2",
        title: "Basics T-Shirt",
        description: "Feel the air wearing it.",
        imageURL:
            "https://images-na.ssl-images-amazon.com/images/I/91lwo2JSKyL._UX466_.jpg",
        price: 749,
      ),
      Product(
        id: "P3",
        title: "Apple iPhone",
        description: "The smartphone you never imagined.",
        imageURL:
            "https://specials-images.forbesimg.com/imageserve/5eebf1a63f00c50007f33477/960x0.jpg?fit=scale",
        price: 99999,
      ),
      Product(
        id: "P4",
        title: "Mac Book",
        description: "The world is on your table.",
        imageURL:
            "https://5.imimg.com/data5/XI/KO/MY-16701245/apple-macbook-air-mqd32hn-a-13-3-inch-laptop-2017-core-i5-8-500x500.jpg",
        price: 69999,
      ),
    ];
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
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (contxt, index) => ProductItem(
          id: loadedProducts[index].id,
          title: loadedProducts[index].title,
          imageURL: loadedProducts[index].imageURL,
        ),
        itemCount: loadedProducts.length,
      ),
    );
  }
}
