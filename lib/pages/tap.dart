import 'package:flutter/material.dart';
// import 'package:local_shopee/pages/cart.dart';
import 'package:local_shopee/pages/home.dart';
import 'package:local_shopee/pages/profile.dart';

class TapBar extends StatefulWidget {
  const TapBar({super.key});

  @override
  State<TapBar> createState() => _TapBarState();
}

class _TapBarState extends State<TapBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        //appBar: AppBar(title: const Text('Tap Bar Example')),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorite'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
            Tab(icon: Icon(Icons.account_circle), text: 'Profile'),
          ],
        ),
        body: const TabBarView(
          children: [
            HomePage(),
            Center(child: Text('Content for Favorite')),
            // CartPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
