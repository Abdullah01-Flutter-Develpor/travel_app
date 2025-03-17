import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/routers/route_path_class.dart';
import 'package:travel_app/screens/feature_widegt.dart/feature_widget.dart';

class FeaturesList extends StatefulWidget {
  const FeaturesList({
    Key? key,
    required this.cityName,
    required this.cityId,
  }) : super(key: key);

  final String cityName;
  final String cityId;

  @override
  State<FeaturesList> createState() => _FeaturesListState();
}

class _FeaturesListState extends State<FeaturesList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  final List<Map<String, dynamic>> features = [
    {
      'name': 'Recommended',
      'icon': Icons.recommend,
      'route': RoutePathClass.pathRecomended,
      'color': Color(0xFF4CAF50), // green
    },
    {
      'name': 'Guide',
      'icon': Icons.person,
      'route': RoutePathClass.pathGuide,
      'color': Color(0xFF2196F3), // blue
    },
    {
      'name': 'Gallery',
      'icon': Icons.photo,
      'route': RoutePathClass.pathGallery,
      'color': Color(0xFFFF9800), // orange
    },
    {
      'name': 'Hotels',
      'icon': Icons.hotel,
      'route': RoutePathClass.pathHotels,
      'color': Color(0xFF9C27B0), // purple
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          physics: const BouncingScrollPhysics(),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: 85,
                child: FeatureWidget(
                  name: feature['name'],
                  icon: feature['icon'],
                  cityId: widget.cityId,
                  accentColor: feature['color'],
                  onTap: () {
                    context.go(
                      '/${RoutePathClass.pathCity}/${widget.cityName}/${widget.cityId}/${feature['route']}',
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
