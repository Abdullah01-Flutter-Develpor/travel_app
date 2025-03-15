import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id; // Add this field
  final String userName;
  final String comment;
  final int rating;
  final DateTime timestamp;
  final String cityId;

  Review({
    required this.id, // Add this field
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp,
    required this.cityId,
  });

  factory Review.fromJson(Map<String, dynamic> json, String id) {
    return Review(
      id: id, // Pass the document ID
      userName: json['userName'],
      comment: json['comment'],
      rating: json['rating'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      cityId: json['cityId'],
    );
  }
}
