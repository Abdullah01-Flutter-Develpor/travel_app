import 'package:flutter/material.dart';
import 'package:travel_app/colors/color_class.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.onDelete,
  });

  final String reviewerName;
  final String reviewText;
  final int rating;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorsClass.lightGrey,
                    radius: 24, // Adjusted radius
                    child: const Icon(Icons.person,
                        color: Colors.black, size: 28), // Adjusted icon size
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Use Expanded to prevent overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reviewerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle long names
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < rating) {
                              return const Icon(Icons.star,
                                  color: Colors.amber,
                                  size: 18); // Adjusted star size
                            } else {
                              return const Icon(Icons.star_border,
                                  color: Colors.amber, size: 18);
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                reviewText,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Delete Review',
              style: TextStyle(fontWeight: FontWeight.w600)),
          content: const Text('Are you sure you want to delete this review?',
              style: TextStyle(color: Colors.black87)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
              child: const Text('Delete',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }
}
