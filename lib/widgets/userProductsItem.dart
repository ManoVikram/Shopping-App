import 'package:flutter/material.dart';

class UserProductsItem extends StatelessWidget {
  final String title;
  final String imageURL;

  UserProductsItem(this.title, this.imageURL);

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
