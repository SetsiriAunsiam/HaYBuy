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
            return false;
          },
          child: RefreshIndicator(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:  const Text(
                    "หมวดหมู่สินค้า",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.location_on_sharp, size: 40),
                            color: Colors.red,
                          ),
                          SizedBox(height: 5),
                          const Text("สินค้าใกล้ฉัน", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10,),
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.electric_bolt_sharp, size: 40),
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          const Text("เครื่องใช้ไฟฟ้า", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12,),
                      Column(
                        children: [
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.person_outlined, size: 40),
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          const Text("เสื้อผ้า", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10,),
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.book_outlined, size: 40),
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          const Text("หนังสือ", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        children: [
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.chair_outlined, size: 40),
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          const Text("เฟอร์นิเจอร์", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10,),
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.motorcycle_outlined, size: 40),
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          const Text("หนังสือ", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),    
                      Column(
                        children: [
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.chair_outlined, size: 40),
                            color: Colors.black,
                          ),
                          SizedBox(height: 5),
                          const Text("กีฬา", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10,),
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade100),
                            ),
                            onPressed: (){}, 
                            icon: Icon(Icons.motorcycle_outlined, size: 40),
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5),
                          const Text("แก็ดเจ็ต", 
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),     
                    ],
                  ),
                ),
                const SizedBox(height: 10 ),
                
                Expanded(
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
                ),
              ],
            ),
            
            onRefresh: () => context.read<ProductProvider>().refreshProducts(), 

          )
        )
      );
  
  }
}
