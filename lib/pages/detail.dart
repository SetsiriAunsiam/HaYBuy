import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Product Name', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('Product Description', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add to cart logic here
                debugPrint('Add to Cart button pressed');
              },
              child: const Text('Add to Cart'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous page
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}