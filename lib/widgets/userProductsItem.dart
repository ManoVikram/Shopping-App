import 'package:flutter/material.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String imageURL;

  UserProductsItem(this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
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
        width: 150,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
