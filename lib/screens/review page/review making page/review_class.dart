import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userName;
  final String comment;
  final int rating;
  final DateTime timestamp;
  final String cityId;

  Review({
    required this.id,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp,
    required this.cityId,
  });

  factory Review.fromJson(Map<String, dynamic> json, String id) {
    Timestamp? timestamp = json['timestamp'] as Timestamp?; // Allow null

    return Review(
      id: id,
      userName: json['userName'] ?? '', // Add null-aware operator
      comment: json['comment'] ?? '', // Add null-aware operator
      rating: json['rating'] ?? 0, // Add null-aware operator
      timestamp: timestamp?.toDate() ?? DateTime.now(), // Handle null
      cityId: json['cityId'] ?? '', // Add null-aware operator
    );
  }
}
