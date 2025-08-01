import 'package:flutter/material.dart';

PreferredSizeWidget customAppbar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,}){
    return AppBar(
      title: Text(title),
      actions: actions ??[
        IconButton(
          onPressed: (){}, 
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
       
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
            onChanged: (value) {
            },
          ),
        ),
      ),
    );

}

