import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/control_room/control_data.dart';
import 'package:get/get.dart';
import 'package:travel_app/routers/route_path_class.dart';
import 'package:travel_app/screens/HomeScreen.dart';
import 'package:travel_app/screens/auth/login_screen.dart';
import 'package:travel_app/screens/auth/signup_screen.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_page.dart';
import 'package:travel_app/screens/gallery%20page/widgets/gallery_main_page.dart';
import 'package:travel_app/screens/guide/widgets/guide_main_page.dart';
import 'package:travel_app/screens/hotels/widgets/hotel_main_page.dart';
import 'package:travel_app/screens/recomendation/widgets/recomendation_place_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  // Using nullable GoRouter for better initialization handling
  static GoRouter? _router;
  static GoRouter get router => _router!;

  static Future<void> initRouter(Function(Locale) onLocaleChanged) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      final DataController dataController = Get.find<DataController>();

      _router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: _getInitialRoute(isFirstLaunch, isLoggedIn),
        redirect: (context, state) {
          final isLoggedIn = dataController.firebaseUser.value != null;
          final isGoingToLogin =
              state.matchedLocation == RoutePathClass.loginPath;
          final isGoingToSignup =
              state.matchedLocation == RoutePathClass.signupPath;

          // If user is not logged in and not going to auth pages, redirect to login
          if (!isLoggedIn && !isGoingToLogin && !isGoingToSignup) {
            return RoutePathClass.loginPath;
          }

          // If user is logged in and trying to access auth pages, redirect to home
          if (isLoggedIn && (isGoingToLogin || isGoingToSignup)) {
            return RoutePathClass.initialPath;
          }

          return null;
        },
        routes: <RouteBase>[
          // Auth routes
          GoRoute(
            path: RoutePathClass.signupPath,
            name: 'signup',
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: RoutePathClass.loginPath,
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),

          // Main app routes
          GoRoute(
            path: RoutePathClass.initialPath,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: '${RoutePathClass.pathCity}/:cityName/:cityId',
                name: 'cityPage',
                builder: (BuildContext context, GoRouterState state) {
                  final String cityName = state.pathParameters['cityName']!;
                  final String cityId = state.pathParameters['cityId']!;

                  return CityPage(
                    cityName: cityName,
                    cityId: cityId,
                    // onLocaleChanged: onLocaleChanged,
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: RoutePathClass.pathRecomended,
                    builder: (BuildContext context, GoRouterState state) {
                      final String cityId = state.pathParameters['cityId']!;
                      return RecomendationPlacesPage(cityId: cityId);
                    },
                  ),
                  GoRoute(
                    path: RoutePathClass.pathGuide,
                    builder: (BuildContext context, GoRouterState state) {
                      final String cityId = state.pathParameters['cityId']!;
                      return GuideMainPageWidget(cityId: cityId);
                    },
                  ),
                  GoRoute(
                    path: RoutePathClass.pathGallery,
                    builder: (BuildContext context, GoRouterState state) {
                      final String cityId = state.pathParameters['cityId']!;
                      return GalleryPage(cityId: cityId);
                    },
                  ),
                  GoRoute(
                    path: RoutePathClass.pathHotels,
                    builder: (BuildContext context, GoRouterState state) {
                      final String cityId = state.pathParameters['cityId']!;
                      return HotelMainPage(cityId: cityId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        errorBuilder: (context, state) => Scaffold(
          body: Center(
            child: Text('Route not found: ${state.uri.path}'),
          ),
        ),
      );

      print("Router initialized successfully");
    } catch (e) {
      print("Error initializing router: $e");
      // Fallback to simple router in case of errors
      _router = GoRouter(
        initialLocation: RoutePathClass.loginPath,
        routes: [
          GoRoute(
            path: RoutePathClass.loginPath,
            builder: (context, state) => const LoginScreen(),
          ),
        ],
      );
    }
  }

  static String _getInitialRoute(bool isFirstLaunch, bool isLoggedIn) {
    if (isFirstLaunch) {
      return RoutePathClass.signupPath;
    } else if (!isLoggedIn) {
      return RoutePathClass.loginPath;
    } else {
      return RoutePathClass.initialPath;
    }
  }

  // Helper method to mark first launch complete
  static Future<void> completeFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }

  // Helper method to mark user as logged in
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }
}
