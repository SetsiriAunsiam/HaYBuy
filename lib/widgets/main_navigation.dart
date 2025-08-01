import 'package:flutter/material.dart';
import 'package:local_shopee/providers/navigation_provider.dart';
import 'package:local_shopee/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> appBarTitle = const [
    "Market",
    "Search",
    "Favorite",
    "Profile"
  ];

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
      appBar: customAppbar(context: context, title: appBarTitle[navProvider.currentIndex]),
      body: pages[navProvider.currentIndex],
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top:10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () => debugPrint("Add button passed"),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: Colors.green),
            borderRadius: BorderRadius.circular(100)
          ),
          child: const Icon(
            Icons.add,
            color: Colors.green,
            
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(218, 255, 219, 1),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: navProvider.currentIndex,
        // showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) return; // ข้ามปุ่มว่าง
          navProvider.setIndex(index > 2 ? index - 1 : index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
