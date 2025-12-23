import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../models/product.dart';
// import '../providers/product_provider.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<ProductProvider>();

    return GestureDetector(
      child: Card.outlined(
      // color: Colors.green.withOpacity(0.2),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // if you need this
      side: BorderSide(
        color: Colors.grey,
        width: 1,
       ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              'https://picsum.photos/200',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child:Text(
                          product.name  ,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ), 
                      ),
                      
                      IconButton(
                        icon: Icon(
                          // product.isFavorite
                          //     ? Icons.favorite
                          //     : Icons.favorite_outline,
                          Icons.favorite_outline,
                          color: Colors.red,
                          size: 20,
                          
                        ),
                        onPressed: () {

                        },
                      ),
                    ],
                  ),
                  Text(
                    '฿${product.price}',
                    style: TextStyle(
                      color: Colors.green ,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'คอหงส์',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${product.rating}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: product.id);
      },
    );
    
    
  }
}
