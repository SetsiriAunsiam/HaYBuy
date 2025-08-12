import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_shopee/providers/product_provider.dart';
import 'package:provider/provider.dart';

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
          final productLocation = productData['location'] as GeoPoint? ?? GeoPoint(0, 0);

          final locationProvider = Provider.of<ProductProvider>(context);

          if (locationProvider.currentPosition == null) {
            locationProvider.fetchCurrentLocation().then((_) {
              locationProvider.calculateDistance(productLocation);
            });
          }

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
              
              Text(
                productData['name'] ?? 'Unnamed Product',
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  const SizedBox(width: 5),
                  Text(
                     locationProvider.distanceInMeters == null
                      ? 'กำลังคำนวณระยะทาง...'
                      : '${(locationProvider.distanceInMeters! / 1000).toStringAsFixed(2)} กม.',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  Icon( 
                    Icons.av_timer_outlined,
                    color: Colors.black,
                    size: 20,),
                    SizedBox(width: 4),
                  Text(
                    productData['createdAt'] != null
                        ? (() {
                            final createdAt = productData['createdAt'].toDate() as DateTime;
                            final now = DateTime.now();
                            final difference = now.difference(createdAt);

                            if (difference.inDays >= 1) {
                              return '${difference.inDays} วันที่แล้ว';
                            } else if (difference.inHours >= 1) {
                              return '${difference.inHours} ชั่วโมงที่แล้ว';
                            } else if (difference.inMinutes >= 1) {
                              return '${difference.inMinutes} นาทีที่แล้ว';
                            } else {
                              return 'ไม่กี่วินาทีที่แล้ว';
                            }
                          })()
                        : 'ไม่ทราบวันเวลา',
                    style: const TextStyle(fontSize: 16),
                  )
                ],
                
              ),  
              Text(
                "รายละเอียดสินค้า",
                 style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                productData['description'] ?? "ไม่มีรายละเอียด",
                style: const TextStyle(fontSize: 16),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('รีวิวผู้ขาย', 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        
                        Text('4.5', 
                        style: const TextStyle(
                          fontSize: 50, 
                          fontWeight: FontWeight.bold
                          )
                        ),
                        
                        Icon( 
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('จำนวนผู้ซื้อ', 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          productData['buyerCount']?.toString() ?? '0',
                          style: const TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ) 
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        productData['sellerImageUrl'] ?? 'https://picsum.photos/200',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ผู้ขาย', 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          productData['sellerName'] ?? 'ไม่ทราบชื่อผู้ขาย',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 108, 254, 113),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Handle contact seller action
                      },
                      child: const Text('ดูผู้ขาย',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                
              ),
            ],
            ),
          );
        },
      ),  
      
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.chat_bubble, color: Color.fromARGB(255, 121, 238, 125)),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 121, 238, 125)),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
              ],

            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 254, 113),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                //  minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // Handle buy now action
              },
              child: const Text('ซื้อเลย',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
      
  }
}