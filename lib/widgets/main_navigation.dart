import 'package:flutter/material.dart';
import 'package:local_shopee/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> pages = const [
    HomePage(),
    Center(child: Text('Search Page')),
    CartPage(),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: pages[navProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(218, 255, 219, 1),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: navProvider.currentIndex,
        // showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (index) => navProvider.setIndex(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
