import 'package:flutter/material.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:provider/provider.dart';

// import 'widgets/custom_appbar.dart';
// import 'widgets/card.dart';

import 'pages/home.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        // ChangeNotifierProvider(create: (context) => Product()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ซ่อนแถบ debug
      title: 'My Shop App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(), // ชี้ไปหน้า Home
    );
  }
  
}
