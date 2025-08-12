import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_shopee/models/product.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {

  // final productItem = ModalRoute.of(context)?.settings.arguments as Product;
  final productId = ModalRoute.of(context)?.settings.arguments as String;
  final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: productRef.get(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Product not found'));
          }

          final productData = snapshot.data!.data() as Map<String, dynamic>;
          return  SingleChildScrollView(  
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://picsum.photos/200',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 252, 201),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        productData['status'] ?? 'ไม่ทราบสถานะ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ) ,
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 252, 201),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        productData['category'] ?? 'No Category',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ) 
                      ],
                    )
                    
                  ),
                  
                  Text(
                    '\$${(productData['price'] ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 35,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 2.0),
              Text(
                      productData['name'] ?? "Unnamed product",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Text(
                productData['description'] ?? "No description",
                style: const TextStyle(fontSize: 16),
              ),
            ],
            ),
          );
        },
      ),  
    );
      
  }
}