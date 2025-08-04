import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:decimal/decimal.dart';

class ProductProvider with ChangeNotifier {
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

  void toggleFavorite(String id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
  }



}