import 'package:decimal/decimal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final String sellerId;
  final GeoPoint location;
  final Decimal price;
  final Decimal rating;
  final String status;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.imageUrl = '',
    required this.sellerId,
    required this.location,
    required this.price,
    required this.rating,
    this.status = 'available',
  });
}