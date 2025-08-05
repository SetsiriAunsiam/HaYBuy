import 'package:decimal/decimal.dart';

class Product {
  final String id;
  final String name;
  final String location;
  final Decimal price;
  final Decimal rating;
  bool isFavorite;

  Product({
    required this.id, 
    required this.name, 
    required this.location, 
    required this.price, 
    required this.rating, 
    this.isFavorite = false
  });
}