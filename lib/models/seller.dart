import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String id;
  final String displayName;
  final GeoPoint location;
  final int ratingOne;
  final int ratingTwo;
  final int ratingThree;  
  final int ratingFour;
  final int ratingFive;

  Seller({
    required this.id,
    required this.displayName,
    required this.location,
    this.ratingOne = 0,
    this.ratingTwo = 0,
    this.ratingThree = 0,
    this.ratingFour = 0,
    this.ratingFive = 0,
  });
}