import 'package:flutter/material.dart';
import 'package:travel_app/colors/color_class.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.onDelete, // Callback for delete action
  });

  final String reviewerName;
  final String reviewText;
  final int rating;
  final VoidCallback onDelete; // Callback to handle review deletion

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Show a dialog on long press
        _showDeleteDialog(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.blue),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
              blurStyle: BlurStyle.outer,
            ),
          ],
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
                    child: const Icon(Icons.person, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    reviewerName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  if (index < rating) {
                    return const Icon(Icons.star, color: Colors.amber);
                  } else {
                    return const Icon(Icons.star_border, color: Colors.amber);
                  }
                }),
              ),
              const SizedBox(height: 16),
              Text(
                reviewText,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the delete dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Review'),
          content: const Text('Are you sure you want to delete this review?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the onDelete callback to delete the review
                onDelete();
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
