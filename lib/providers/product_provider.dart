import 'dart:async';
import 'dart:io';
// import 'dart:math';

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:decimal/decimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  File? _imageFile;
  bool _isSubmitting = false;

  // Getter สำหรับให้ UI ดึงค่าไปใช้
  File? get imageFile => _imageFile;
  bool get isSubmitting => _isSubmitting;

  // Logic การเลือกรูปภาพ
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  final collection = FirebaseFirestore.instance.collection("products");
  final user = FirebaseAuth.instance.currentUser;

  final int _limit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  bool get hasmore => _hasMore;

  final List<Product> _productsDb = [];
  List<Product> get productsDb => _productsDb;

  Future<Product?> getProductById(String id) async {
    try {
      final doc = await collection.doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          sellerId: data['sellerId'] ?? user?.uid ?? 'unknown',
          location: data['location'] ?? GeoPoint(0.0, 0.0),
          price: Decimal.parse(data['price'] ?? 0),
          rating: Decimal.parse(data['rating']?.toString() ?? '0'),
          status: data['status'] ?? 'available',
        );
      }
    } catch (e) {
      print('Error fetching product by ID: $e');
    }
    return null;
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
      if (snapshot.docs.length < _limit) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
    }
  }

  Future<bool> submitProduct(
    Product product) async {
    if (_imageFile == null) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();
    try {
      await collection.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': product.name,
        'description': product.description,
        'category': product.category,
        'imageUrl': 'https://example.com/image.jpg',
        'sellerId': user?.uid ?? 'unknown',
        'location': product.location,
        'price': product.price.toString(),
        'rating': Decimal.parse('0.0').toString(),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'ขาย',
      });
      _isSubmitting = false;
      _imageFile = null;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error adding product: $e');
      _isSubmitting = false;
      notifyListeners();
      return false;
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
