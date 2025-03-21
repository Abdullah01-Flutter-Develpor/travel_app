import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId; // Added userId field
  final String userName;
  final String comment;
  final int rating;
  final DateTime timestamp;
  final String cityId;

  Review({
    required this.id,
    required this.userId, // Added userId parameter
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
      userId: json['userId'] ?? '', // Extract userId from JSON
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      timestamp: timestamp?.toDate() ?? DateTime.now(),
      cityId: json['cityId'] ?? '',
    );
  }
}
