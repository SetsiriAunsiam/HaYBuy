import 'package:flutter/material.dart';
import 'package:local_shopee/pages/favorite.dart';

PreferredSizeWidget customAppbar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,}){
    return AppBar(
      title: Text(title),
      actions: actions ??[
        IconButton(
          onPressed: (){ 
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const DetailPage()),
            // );
          }, 
          icon: const Icon(
            Icons.chat,
          )
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(
            Icons.notification_add,
          )
        ),
        IconButton(
          onPressed: (){ 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritePage()),
            );
          }, 
          icon: const Icon(
            Icons.favorite_border,
          )
        ),
       
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
            child: AbsorbPointer( 
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ค้นหาสินค้า...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

}

