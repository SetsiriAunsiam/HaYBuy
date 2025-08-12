import 'package:flutter/material.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:provider/provider.dart';
// import 'package:local_shopee/widgets/custom_appbar.dart';
import 'package:local_shopee/widgets/card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<ProductProvider>(context).favoriteProductsDb;

     return  Scaffold(
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 5,
            childAspectRatio: 0.7,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return ProductCard(product: favorites[index]);
          },
        ),
      );
  }
}
