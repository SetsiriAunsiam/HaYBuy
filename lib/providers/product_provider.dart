import 'dart:async';

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:decimal/decimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider with ChangeNotifier {

  final collection = FirebaseFirestore.instance.collection("products");
  
  final List<Product> _products = [
    Product(id: '1', name: 'Item 1', location: "คอหงศ์", price: Decimal.fromInt(200), rating: Decimal.fromInt(5)),
    Product(id: '2', name: 'Item 2', location: "คอหงศ์", price: Decimal.fromInt(120), rating: Decimal.parse("3.5")),
    Product(id: '3', name: 'Item 3', location: "คอหงศ์", price: Decimal.fromInt(333), rating: Decimal.parse("2.3")),
    Product(id: '4', name: 'Item 4', location: "คอหงศ์", price: Decimal.fromInt(444), rating: Decimal.fromInt(5)),
    Product(id: '5', name: 'Item 5', location: "คอหงศ์", price: Decimal.fromInt(555), rating: Decimal.fromInt(5)),
    Product(id: '6', name: 'Item 6', location: "คอหงศ์", price: Decimal.fromInt(666), rating: Decimal.parse("3.3")),
    Product(id: '7', name: 'Item 7', location: "คอหงศ์", price: Decimal.fromInt(123), rating: Decimal.parse("4.7")),
    Product(id: '8', name: 'Item 8', location: "คอหงศ์", price: Decimal.fromInt(321), rating: Decimal.fromInt(5)),
  ];
  List<Product> get products => _products;
  List<Product> get favoriteProducts => _products.where((p) => p.isFavorite).toList();


  final List<Product> _productsDb = [];
  List<Product> get productsDb => _productsDb;
  List<Product> get favoriteProductsDb => _productsDb.where((p) => p.isFavorite).toList();

  ProductProvider() {
    loadProductsFromDb();
    startListening();
  }

  StreamSubscription? _subscription;
  void startListening() {
    _subscription = collection.snapshots().listen((snapshot) {
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
    });
  }

  Future<void> loadProductsFromDb() async {
    try {
      final snapshot = await collection.get();
      _products.clear();
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

 void stopListening() {
    _subscription?.cancel();
  }

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
      } catch (e) {
        print('Error updating favorite status: $e');
        _productsDb[index].isFavorite = isFavorite;
        notifyListeners();
      }
    } else {
      print('Document does not exist');
    }
  }
  





  // void toggleFavorite(String id) {
  //   final index = _products.indexWhere((p) => p.id == id);
  //   if (index != -1) {
  //     _products[index].isFavorite = !_products[index].isFavorite;
  //     notifyListeners();
  //   }
  // }



  addProduct() async {
    try {
      final product = Product(
        id: DateTime.now().toString(),
        name: 'New Product',
        location: 'คอหงส์',
        price: Decimal.fromInt(100),
        rating: Decimal.fromInt(4),
      );
      await collection.add({
        'name': product.name,
        'location': product.location,
        'price': product.price.toString(),
        'rating': product.rating.toString(),
        'isFavorite': false,
      });
    } catch (e) {
      print('Error adding product: $e');
    }
    notifyListeners();
  }

}