import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_shopee/pages/cart.dart';
import 'package:local_shopee/pages/detail.dart';
import 'package:local_shopee/pages/favorite.dart';
import 'package:provider/provider.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/search_provider.dart';
import 'pages/search.dart';

import 'widgets/main_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
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
      initialRoute: '/',
      routes: {
         '/': (context) => const HomeScreen(),
         '/detail': (context) => const DetailPage(),
         '/cart': (context) => const CartPage(),
         '/favorite': (context) => const FavoritePage(),
         '/search': (context) => const SearchPage(),
      },


      debugShowCheckedModeBanner: false, // ซ่อนแถบ debug
      title: 'My Shop App',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontSize: 30,
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
        primarySwatch: Colors.green,
      ),
      // home: const HomeScreen(), // ชี้ไปหน้า Home
    );
  }
  
}
