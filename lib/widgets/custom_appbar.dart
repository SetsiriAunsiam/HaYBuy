import 'package:flutter/material.dart';

PreferredSizeWidget customAppbar = AppBar(
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
  ],
);

