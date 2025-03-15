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
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemExtent: height * 0.22,
                itemCount: localReviews.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ReviewWidget(
                      reviewerName: 'Local User',
                      reviewText: localReviews[index],
                      rating: 5,
                      onDelete: () {
                        // Handle deletion of local review (if needed)
                        print('Local review deleted');
                      },
                    ),
                  );
                },
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .where('cityId', isEqualTo: cityId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    print('No reviews found for cityId: $cityId');
                    return Center(child: Text('No reviews available.'));
                  }

                  final reviews = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Review.fromJson(
                        data, doc.id); // Pass the document ID
                  }).toList();

                  print(
                      'Fetched ${reviews.length} reviews for cityId: $cityId');
                  for (final review in reviews) {
                    print(
                        'Review: ${review.comment}, CityId: ${review.cityId}');
                  }

                  reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemExtent: height * 0.22,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ReviewWidget(
                          reviewerName: review.userName,
                          reviewText: review.comment,
                          rating: review.rating,
                          onDelete: () async {
                            // Delete the review from Firebase
                            await _deleteReviewFromFirebase(context, review.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  // Function to delete a review from Firebase
  Future<void> _deleteReviewFromFirebase(
      BuildContext context, String reviewId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(reviewId)
          .delete();
    } catch (e) {
      print('Failed to delete review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: $e')),
      );
    }
  }
}
