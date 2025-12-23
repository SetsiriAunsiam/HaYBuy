import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:decimal/decimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class ProductProvider with ChangeNotifier {

  final collection = FirebaseFirestore.instance.collection("products");
  final user = FirebaseAuth.instance.currentUser;

  

  final int _limit = 10;
  DocumentSnapshot? _lastDocument; 
  bool _hasMore = true;

  bool get hasmore => _hasMore;

  final List<Product> _productsDb = [];
  List<Product> get productsDb => _productsDb;


  Position? _currentPosition;
  double? _distanceInMeters;

  Position? get currentPosition => _currentPosition;
  double? get distanceInMeters => _distanceInMeters;

  Future<void> fetchCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    notifyListeners();
  }
  

  void calculateDistance(GeoPoint productLocation) {
    if (_currentPosition == null) {
      _distanceInMeters = null;
      notifyListeners();
      return;
    }
    _distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      productLocation.latitude,
      productLocation.longitude,
    );
    notifyListeners();
  }

Future<Map<String, dynamic>?> fetchProductAndSeller(String productId) async {
  final productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();

  if (!productDoc.exists) return null;

  final productData = productDoc.data();
  if (productData == null) return null;

  final sellerId = productData['sellerId'] as String?;

  Map<String, dynamic>? sellerData;
  if (sellerId != null) {
    final sellerDoc = await FirebaseFirestore.instance.collection('users').doc(sellerId).get();
    if (sellerDoc.exists) {
      sellerData = sellerDoc.data();
    }
  }

  return {
    'product': productData,
    'seller': sellerData,
  };
}

  ProductProvider() {
    loadMoreProducts();
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

  Future<void> refreshProducts() async {
    _productsDb.clear();
    _lastDocument = null;
    _hasMore = true;
    await loadMoreProducts();
  }

  Future<void> loadMoreProducts() async {
    if (!_hasMore) return;
    Query query = collection.orderBy('name').limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
    final snapshot = await query.get();
    print('Load products: new docs ${snapshot.docs.length}');
    print('Current productsDb length: ${_productsDb.length}');  

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      for (var doc in snapshot.docs) {
        final existingIndex = _productsDb.indexWhere((p) => p.id == doc.id);
        if (existingIndex == -1) {
          final data = doc.data() as Map<String, dynamic>;
          _productsDb.add(
            Product(
              id: doc.id,
              name: data['name'] ?? 'Unknown',
              description: data['description'] ?? '',
              category: data['category'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              sellerId: data['sellerId'] ?? user?.uid ?? 'unknown',
              location: data['location'] ?? GeoPoint(0.0, 0.0),
              price: Decimal.parse(data['price']?.toString() ?? '0'),
              rating: Decimal.parse(data['rating']?.toString() ?? '0'),
              status: data['status'] ?? 'available',
            )
          );  
        }
      }
      notifyListeners();
      if(snapshot.docs.length < _limit) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await collection.add({
        'name': product.name,
        'description': product.description,
        'category': product.category,
        'imageUrl': product.imageUrl,
        'sellerId': user?.uid ?? 'unknown',
        'location': product.location,
        'price': product.price.toString(),
        'rating': product.rating.toString(),
        'status': product.status,
      });
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> addTestProduct() async {
    try {
      await collection.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'test1',
        'description': 'test1description',
        'category': 'test',
        'imageUrl': 'https://example.com/image.jpg',
        'sellerId': user?.uid ?? 'unknown',
        'location': GeoPoint(0.0, 0.0),
        'price': 150,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'ขาย',
      });
      print('Product added successfully');
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }


}