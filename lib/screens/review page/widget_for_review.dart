// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/colors/color_class.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.onDelete,
    this.timestamp,
    this.profileImageUrl,
    this.userId, // Add userId to fetch user data
  });

  final String reviewerName;
  final String reviewText;
  final int rating;
  final VoidCallback onDelete;
  final DateTime? timestamp;
  final String? profileImageUrl;
  final String? userId; // Add userId

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  String? userName;
  String? userProfileImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      fetchUserData(widget.userId!);
    }
  }

  Future<void> fetchUserData(String userId) async {
    try {
      print("Fetching user data for userId: $userId");
      final userDoc = await FirebaseFirestore.instance
          .collection('userDetail')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      print("Firestore query result: ${userDoc.docs}"); // Log the query result

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        setState(() {
          userName = userData['name'];
          userProfileImageUrl = userData['profileImageUrl'];
        });
      } else {
        print("User not found in Firestore for userId: $userId");
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: () => _showDeleteDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image (default avatar only)
                    _buildAvatar(),
                    const SizedBox(width: 12),

                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userName ?? widget.reviewerName, // Fallback
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Rating stars
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < widget.rating
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 18,
                                );
                              }),
                              if (widget.timestamp != null) ...[
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    DateFormat('MMM d, y')
                                        .format(widget.timestamp!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    // More options icon
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onPressed: () => _showDeleteDialog(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                // Review content
                const SizedBox(height: 16),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      widget.reviewText,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (userProfileImageUrl != null && userProfileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(userProfileImageUrl!),
        radius: 24,
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorsClass.lightGrey, Colors.grey.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.person, color: Colors.black54, size: 24),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Delete Review',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to delete this review? This action cannot be undone.',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDelete();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}
