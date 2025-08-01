import 'package:flutter/material.dart';
// import 'package:local_shopee/widgets/custom_appbar.dart';
import 'package:local_shopee/widgets/card.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    return
      Scaffold(
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 5,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        ),
      );
    
  }
}
