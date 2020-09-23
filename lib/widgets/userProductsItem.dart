import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/addEditUserProducts.dart';
import '../providers/productsProvider.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageURL;

  UserProductsItem(this.id, this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          imageURL,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText1.toString(),
          fontSize: 22,
          letterSpacing: 4,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                // color: Theme.of(context).primaryColor,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddEditUserProductsScreen.routeName,
                  arguments: id,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                Provider.of<ProductsProvider>(context, listen: false)
                    .removeProduct(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
