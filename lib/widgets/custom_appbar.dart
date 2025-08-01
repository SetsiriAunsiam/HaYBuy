import 'package:flutter/material.dart';
import '../pages/cart.dart';

PreferredSizeWidget customAppbar(BuildContext context){
  return AppBar(
  title: Text(
    "Your Title",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 30
    ),
  ),
  backgroundColor: Colors.green,
  // centerTitle: true,
  actions: <Widget>[
    IconButton(
      onPressed: (){}, 
      icon: const Icon(
        Icons.chat,
        color: Colors.white,
      )
    ),
    IconButton(
      onPressed: (){}, 
      icon: const Icon(
        Icons.notification_add,
        color: Colors.white,
      )
    ),
    IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
      }, 
      icon: Icon(
        Icons.shopping_bag,
        color: Colors.white,
      )
    )
  ],
);

}

