import 'package:flutter/material.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: customAppbar,
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 2,
          mainAxisSpacing: 5,
          childAspectRatio: 0.7, 
          children: const [
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
          ProductCard(),
          
        ],
          ),
      ),

    );
    
  }
}
