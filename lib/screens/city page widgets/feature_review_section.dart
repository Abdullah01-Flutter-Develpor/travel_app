import 'package:flutter/material.dart';
import 'package:travel_app/screens/feature_widegt.dart/feature_list.dart';
import 'package:travel_app/screens/review%20page/review_page.dart';

class FeaturesSection extends StatelessWidget {
  final String cityName;
  final String cityId;

  const FeaturesSection({
    super.key,
    required this.cityName,
    required this.cityId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         AppLocalizations.of(context).explore,
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: theme.primaryColor,
        //         ),
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           // Navigate to full features list
        //         },
        //         child: Text(
        //           'See All',
        //           style: TextStyle(
        //             color: theme.primaryColor,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FeaturesList(
            cityName: cityName,
            cityId: cityId,
          ),
        ),
      ],
    );
  }
}

class ReviewsSection extends StatelessWidget {
  final String cityId;

  const ReviewsSection({
    super.key,
    required this.cityId,
  });

  @override
  Widget build(BuildContext context) {
    return ReviewPage(cityId: cityId);
  }
}
