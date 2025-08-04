import 'package:flutter/material.dart';
import 'package:local_shopee/models/product.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {

  final productItem = ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(productItem.name, style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text( '฿${productItem.price}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text(productItem.location, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Rating: ${productItem.rating}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('isFav? : ${productItem.isFavorite}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            
            
          ],
        ),
      ),
    );
  }
}