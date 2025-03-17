import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/routers/route_path_class.dart';
import 'package:travel_app/screens/HomeScreen.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_page.dart';
import 'package:travel_app/screens/gallery%20page/widgets/gallery_main_page.dart';
import 'package:travel_app/screens/guide/widgets/guide_main_page.dart';
import 'package:travel_app/screens/hotels/widgets/hotel_main_page.dart';
import 'package:travel_app/screens/recomendation/widgets/recomendation_place_page.dart';

GoRouter goRouterConfig(Function(Locale) onLocaleChanged) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RoutePathClass.initialPath,
        builder: (context, state) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path:
                '${RoutePathClass.pathCity}/:cityName/:cityId', // Parent route
            name: 'cityPage',
            builder: (BuildContext context, GoRouterState state) {
              final String cityName =
                  state.pathParameters['cityName']!; // Get from params
              final String cityId =
                  state.pathParameters['cityId']!; // Get from params

              return CityPage(
                cityName: cityName,
                cityId: cityId,
                onLocaleChanged: onLocaleChanged,
              );
            },
            routes: <RouteBase>[
              GoRoute(
                path: RoutePathClass.pathRecomended, // Nested route
                builder: (BuildContext context, GoRouterState state) {
                  final String cityId =
                      state.pathParameters['cityId']!; // Get from parent route
                  return RecomendationPlacesPage(cityId: cityId);
                },
              ),
              GoRoute(
                path: RoutePathClass.pathGuide, // Nested route
                builder: (BuildContext context, GoRouterState state) {
                  final String cityId =
                      state.pathParameters['cityId']!; // Get from parent route
                  return GuideMainPageWidget(cityId: cityId);
                },
              ),
              GoRoute(
                path: RoutePathClass.pathGallery, // Nested route
                builder: (BuildContext context, GoRouterState state) {
                  final String cityId =
                      state.pathParameters['cityId']!; // Get from parent route
                  return GalleryPage(cityId: cityId);
                },
              ),
              GoRoute(
                path: RoutePathClass.pathHotels, // Nested route
                builder: (BuildContext context, GoRouterState state) {
                  final String cityId =
                      state.pathParameters['cityId']!; // Get from parent route
                  return HotelMainPage(cityId: cityId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    // Optional: Add error handling for invalid routes
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri.path}'),
      ),
    ),
  );
}
