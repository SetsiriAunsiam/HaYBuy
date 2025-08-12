import 'package:flutter/material.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:local_shopee/widgets/card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productsDb = context.watch<ProductProvider>().productsDb;
    return
      Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
              context.read<ProductProvider>().loadMoreProducts();
              return true;
            }

            // if (scrollNotification.metrics.pixels == 0) {
            //   context.read<ProductProvider>().refreshProducts();
            //   return true;
            // }
            return false;
          },
          child: RefreshIndicator(
            child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.7,
                ),
                itemCount: productsDb.length,
                itemBuilder: (context, index) {
                  if (index == productsDb.length - 1 && context.read<ProductProvider>().hasmore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ProductCard(product: productsDb[index]);
                },
              ),
            onRefresh: () => context.read<ProductProvider>().refreshProducts(), 
            // GridView.builder(
            //     padding: const EdgeInsets.all(20),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 2,
            //       mainAxisSpacing: 5,
            //       childAspectRatio: 0.7,
            //     ),
            //     itemCount: productsDb.length,
            //     itemBuilder: (context, index) {
            //       return ProductCard(product: productsDb[index]);
            //     },
            //   ),

        )
        
        
              
        
      ));
    
  }
}
