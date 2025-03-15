import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:travel_app/routers/route_path_class.dart';
import 'package:travel_app/screens/feature_widegt.dart/feature_widget.dart';

class FeaturesList extends StatelessWidget {
  FeaturesList({
    super.key,
    required this.cityName,
    required this.cityId,
  });

  final String cityName;
  final String cityId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        FeatureWidget(
          name: 'Recommended',
          icon: Icons.recommend,
          cityId: cityId,
          onTap: () {
            // Navigate to the recommended places page
            context.go(
                '/${RoutePathClass.pathCity}/$cityName/$cityId/${RoutePathClass.pathRecomended}');
          },
        ),
        FeatureWidget(
          name: 'Guide',
          icon: Icons.person,
          cityId: cityId,
          onTap: () {
            // Navigate to the guide page
            context.go(
                '/${RoutePathClass.pathCity}/$cityName/$cityId/${RoutePathClass.pathGuide}');
          },
        ),
        FeatureWidget(
          name: 'Gallery',
          icon: Icons.photo,
          cityId: cityId,
          onTap: () {
            // Navigate to the gallery page
            context.go(
                '/${RoutePathClass.pathCity}/$cityName/$cityId/${RoutePathClass.pathGallery}');
          },
        ),
        FeatureWidget(
          name: 'Hotels',
          icon: Icons.hotel,
          cityId: cityId,
          onTap: () {
            // Navigate to the hotels page
            context.go(
                '/${RoutePathClass.pathCity}/$cityName/$cityId/${RoutePathClass.pathHotels}');
          },
        ),
      ],
    );
  }
}
