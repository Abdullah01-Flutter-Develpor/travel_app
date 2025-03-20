import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/screens/review%20page/review%20making%20page/review_class.dart';
import 'package:travel_app/screens/review%20page/widget_for_review.dart';

class ReviewPage extends StatelessWidget {
  final List<String> localReviews;
  final String cityId;

  ReviewPage({this.localReviews = const [], required this.cityId});

  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return SizedBox(
      width: width,
      child: Center(
        child: localReviews.isNotEmpty
            ? _buildLocalReviews(localReviews, height)
            : _buildFirebaseReviews(context, cityId, height),
      ),
    );
  }

  Widget _buildLocalReviews(List<String> localReviews, double itemHeight) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemExtent: itemHeight * 0.40,
      itemCount: localReviews.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReviewWidget(
                reviewerName: 'Local User',
                reviewText: localReviews[index],
                rating: 5,
                onDelete: () {
                  print('Local review deleted');
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFirebaseReviews(
      BuildContext context, String cityId, double itemHeight) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('cityId', isEqualTo: cityId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No reviews available.'));
        }

        final reviews = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Review.fromJson(data, doc.id);
        }).toList();

        reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemExtent: itemHeight * 0.25,
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ReviewWidget(
                    reviewerName: review.userName,
                    reviewText: review.comment,
                    rating: review.rating,
                    onDelete: () async {
                      await _deleteReviewFromFirebase(context, review.id);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteReviewFromFirebase(
      BuildContext context, String reviewId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(reviewId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: $e')),
      );
    }
  }
}
