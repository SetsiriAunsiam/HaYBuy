import 'package:flutter/material.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:local_shopee/widgets/card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<ProductProvider>().favoriteProductsDb;

     return  Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products')
        ),
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