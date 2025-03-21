import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/screens/review%20page/review%20making%20page/review_class.dart';
import 'package:travel_app/screens/review%20page/widget_for_review.dart';

class ReviewPage extends StatefulWidget {
  final List<String> localReviews;
  final String cityId;

  const ReviewPage({
    super.key,
    required this.cityId,
    this.localReviews = const [],
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ScaffoldMessengerState _scaffoldMessenger;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: width,
        child: Center(
          child: widget.localReviews.isNotEmpty
              ? _buildLocalReviews(widget.localReviews, height)
              : _buildFirebaseReviews(context, widget.cityId, height),
        ),
      ),
    );
  }

  Widget _buildLocalReviews(List<String> localReviews, double itemHeight) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemExtent: itemHeight * 0.35,
      itemCount: localReviews.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ReviewWidget(
              reviewerName: 'Local User',
              reviewText: localReviews[index],
              rating: 5,
              onDelete: () {},
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
          return const Center(
              child: Text('No reviews available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)));
        }

        final reviews = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Review.fromJson(data, doc.id);
        }).toList();

        reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ReviewList(
          reviews: reviews,
          onDelete: _deleteReviewFromFirebase,
          itemHeight: itemHeight,
        );
      },
    );
  }

  Future<void> _deleteReviewFromFirebase(String reviewId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      final reviewDoc = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(reviewId)
          .get();

      if (reviewDoc.exists && reviewDoc.data()?['userId'] == user.uid) {
        await FirebaseFirestore.instance
            .collection('reviews')
            .doc(reviewId)
            .delete();

        _scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Review deleted successfully.')),
        );
      } else {
        _scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('You are not authorized to delete this review.')),
        );
      }
    } catch (e) {
      _scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to delete review: $e')),
      );
    }
  }
}

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final Function(String) onDelete;
  final double itemHeight;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.onDelete,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemExtent: itemHeight * 0.25,
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];

        return ReviewWidget(
          reviewerName: review.userName,
          reviewText: review.comment,
          rating: review.rating,
          onDelete: () => onDelete(review.id),
          userId: review.userId,
          timestamp: review.timestamp,
        );
      },
    );
  }
}
