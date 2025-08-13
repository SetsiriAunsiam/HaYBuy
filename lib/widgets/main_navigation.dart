import 'package:flutter/material.dart';
import 'package:local_shopee/pages/create_product.dart';
import 'package:local_shopee/pages/search.dart';
import 'package:local_shopee/providers/navigation_provider.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:local_shopee/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/cart.dart';
import '../pages/profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> appBarTitle = const [
    "Home",
    "Search",
    "",
    "Favorite",
    "Profile",
  ];

  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    SizedBox.shrink(), // Placeholder for the middle button
    CreateProductPage(),
    ProfilePage(), // Replace placeholder with actual ProfilePage
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);


    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: appBarTitle[navProvider.currentIndex],
      ),
      body: pages[navProvider.currentIndex],
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () {
            productProvider.addTestProduct();
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: Colors.green),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(Icons.add, color: Colors.green),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(218, 255, 219, 1),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        currentIndex: navProvider.currentIndex,
        showUnselectedLabels: false,
        onTap: (index) {
          debugPrint("Selected index: $index");
          debugPrint("Selected nav index: ${navProvider.currentIndex}");
          if (index == 2) return;
          navProvider.setIndex(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
