import 'package:flutter/material.dart';
import '../pages/cart.dart';

PreferredSizeWidget customAppbar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,}){
    return AppBar(
      title: Text(title),
      actions: actions ??[
        IconButton(
          onPressed: (){}, 
          icon: const Icon(
            Icons.chat,
          )
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(
            Icons.notification_add,
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
          )
        )
      ],
    );

}

