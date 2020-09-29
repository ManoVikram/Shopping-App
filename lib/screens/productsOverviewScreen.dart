import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/productsGrid.dart';
import '../widgets/badge.dart';
import '../widgets/appDrawer.dart';
import '../providers/productsProvider.dart';
import '../models/cart.dart';
import '../screens/cartScreen.dart';

enum PopupMenuIndex {
  WishList,
  ShowAll,
}

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).fetchProducts(); => Will not work as 'context' is not available | Will work if 'listen: false' is set.
    // 'context' is not available because, 'initState()' runs before everything in the class, while contents aren't properly initialized/wired-up.

    // ----- Below method will work(it's a kinda hack) -----
    /* Future.delayed(Duration.zero).then(
      (value) {
        Provider.of<ProductsProvider>(context).fetchProducts();
      },
    ); */
    // Other method, by using didChangeDependencies()'
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Unlike 'initState()', 'didChangeDependencies()' runs multiple times.
    // Runs before 'build'.

    // 'async', 'await' cannot be used as 'didChangeDependencies()' is an in-built,
    // overrided function. So, the return type can't be changed to 'Future' as 'async' returns 'Future'
    // Thus, '.then()' is used.
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchProducts().then(
        (value) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (contxt) => [
              PopupMenuItem(
                child: Text("Wish List"),
                value: PopupMenuIndex
                    .WishList, // Index can also be directly specifies - 0
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: PopupMenuIndex
                    .ShowAll, // Index can also be directly specifies - 1
              ),
            ],
            onSelected: (PopupMenuIndex value) {
              setState(() {
                if (value == PopupMenuIndex.WishList) {
                  /* productData.showFavouritesOnly(); */
                  // Turning this 'Stateless' widget to 'Stateful' widget is a better option, istead of using 'Providers' in this case
                  _showFavourites = true;
                } else {
                  /* productData.showAll(); */
                  _showFavourites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            // 'Provider.of<Cart>(context)' makes the entire build method to run as it needs to be defined before 'return'
            // 'Consumer<Cart>()' rebuilds only the required data
            builder: (contxt, cart, childArg) {
              return Badge(
                value: cart.numberOfCartItems.toString(),
                child: childArg, // Data in 'childArg' will not be re-buit
                color: null,
              );
            },
            // 'child' argument of 'Consumer<>()' will not be re-built
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavourites),
    );
  }
}
