import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favoriteItems = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get favoriteItems => _favoriteItems;
  bool get isLoading => _isLoading;

  // เริ่มฟังการเปลี่ยนแปลงข้อมูล Favorite
  void startListening() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
          _favoriteItems = snapshot.docs.map((doc) {
            var data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
          notifyListeners();
        });
  }

  // เพิ่มสินค้าเข้า Favorites
  Future<void> addToFavorites({
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
    required String sellerId,
    required String sellerName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(productId)
          .set({
            'productId': productId,
            'productName': productName,
            'price': price,
            'imageUrl': imageUrl,
            'sellerId': sellerId,
            'sellerName': sellerName,
            'addedAt': Timestamp.now(),
          });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('ไม่สามารถเพิ่มสินค้าเข้ารายการโปรดได้: $e');
    }
  }

  // ลบสินค้าออกจาก Favorites
  Future<void> removeFromFavorites(String productId) async {
    try {
      _isLoading = true;
      notifyListeners();

      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(productId)
          .delete();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('ไม่สามารถลบสินค้าออกจากรายการโปรดได้: $e');
    }
  }

  // ตรวจสอบว่าสินค้าอยู่ใน Favorites หรือไม่
  bool isFavorite(String productId) {
    return _favoriteItems.any((item) => item['productId'] == productId);
  }

  // ล้างข้อมูล Favorites
  void clearFavorites() {
    _favoriteItems.clear();
    notifyListeners();
  }

  // สร้างสินค้าหลอกๆ สำหรับทดสอบ
  List<Map<String, dynamic>> getDummyFavoriteProducts() {
    return [
      {
        'id': 'fav1',
        'productId': 'prod1',
        'productName': 'iPhone 14 Pro Max',
        'price': 45900.0,
        'imageUrl': '',
        'sellerId': 'seller1',
        'sellerName': 'ร้านมือถือดี',
        'addedAt': Timestamp.now(),
        'rating': 4.8,
        'distance': '1.2 กิโลเมตร',
      },
      {
        'id': 'fav2',
        'productId': 'prod2',
        'productName': 'MacBook Air M2',
        'price': 42900.0,
        'imageUrl': '',
        'sellerId': 'seller2',
        'sellerName': 'ร้านคอมพิวเตอร์',
        'addedAt': Timestamp.now(),
        'rating': 4.9,
        'distance': '0.8 กิโลเมตร',
      },
      {
        'id': 'fav3',
        'productId': 'prod3',
        'productName': 'AirPods Pro 2',
        'price': 8900.0,
        'imageUrl': '',
        'sellerId': 'seller3',
        'sellerName': 'ร้านอุปกรณ์เสียง',
        'addedAt': Timestamp.now(),
        'rating': 4.7,
        'distance': '2.1 กิโลเมตร',
      },
      {
        'id': 'fav4',
        'productId': 'prod4',
        'productName': 'iPad Pro 11"',
        'price': 28900.0,
        'imageUrl': '',
        'sellerId': 'seller4',
        'sellerName': 'ร้านแท็บเล็ต',
        'addedAt': Timestamp.now(),
        'rating': 4.6,
        'distance': '1.5 กิโลเมตร',
      },
    ];
  }
}
