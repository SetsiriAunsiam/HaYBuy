import 'dart:async';

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:decimal/decimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductProvider with ChangeNotifier {

  final collection = FirebaseFirestore.instance.collection("products");
  final user = FirebaseAuth.instance.currentUser;

  final List<Product> _productsDb = [];
  List<Product> get productsDb => _productsDb;
  List<Product> get favoriteProductsDb => _productsDb.where((p) => p.id == user?.uid && p.isFavorite).toList();

  ProductProvider() {
    loadProductsFromDb();
    // startListening();
  }

  // StreamSubscription? _subscription;
  // void startListening() {
  //   _subscription = collection.snapshots().listen((snapshot) {
  //     _productsDb.clear();
  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       _productsDb.add(Product(
  //         id: doc.id,
  //         name: data['name'] ?? 'Unknown',
  //         location: data['location'] ?? 'Unknown',
  //         price: Decimal.parse(data['price']?.toString() ?? '0'),
  //         rating: Decimal.parse(data['rating']?.toString() ?? '0'),
  //         isFavorite: data['isFavorite'] ?? false,
  //       ));
  //     }
  //     notifyListeners();
  //   });
  // }

  Future<void> loadProductsFromDb() async {
    try {
      final snapshot = await collection.get();
      _productsDb.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        _productsDb.add(Product(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          location: data['location'] ?? 'Unknown',
          price: Decimal.parse(data['price']?.toString() ?? '0'),
          rating: Decimal.parse(data['rating']?.toString() ?? '0'),
          isFavorite: data['isFavorite'] ?? false,
        ));
      }
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
    }
  }

//  void stopListening() {
//     _subscription?.cancel();
//   }

  void toggleFavoriteDb(String id) async {
    final index = _productsDb.indexWhere((p) => p.id == id);
    if (index == -1) return;

    _productsDb[index].isFavorite = !_productsDb[index].isFavorite;
    notifyListeners();

    final item = collection.doc(id);
    final doc = await item.get();
    if (doc.exists) {
      final isFavorite = doc.data()?['isFavorite'] ?? false;
      try {
        await item.update({'isFavorite': _productsDb[index].isFavorite});
        print('fav by ${user?.uid} : ${_productsDb[index].isFavorite}');
      } catch (e) {
        print('Error updating favorite status: $e');
        _productsDb[index].isFavorite = isFavorite;
        notifyListeners();
      }
    } else {
      print('Document does not exist');
    }
  }

  addProduct() async {
    try {
      final product = Product(
        id: user?.uid ?? 'null',
        name: 'New Product',
        location: 'คอหงส์',
        price: Decimal.fromInt(100),
        rating: Decimal.fromInt(4),
      );
      await collection.add({
        'id': user?.uid ?? 'null',
        'name': product.name,
        'location': product.location,
        'price': product.price.toString(),
        'rating': product.rating.toString(),
        'isFavorite': false,
      });
      _productsDb.add(product);
      print('Product added: ${product.name} by ${user?.uid}');
    } catch (e) {
      print('Error adding product: $e');
    }
    notifyListeners();
  }

}