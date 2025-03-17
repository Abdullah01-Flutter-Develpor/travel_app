// city_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_app_bar.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_content.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_page_header.dart';

class CityPage extends StatefulWidget {
  const CityPage({
    super.key,
    required this.cityName,
    required this.cityId,
    required this.onLocaleChanged,
    this.imageUrl,
  });

  final String cityName;
  final String cityId;
  final Function(Locale) onLocaleChanged;
  final String? imageUrl;

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 150 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 150 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        GoRouterState.of(context).extra as String; // Debugging print

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CityAppBar(
        cityName: widget.cityName,
        showTitle: _showAppBarTitle,
        onLocaleChanged: widget.onLocaleChanged,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: CityHeader(
              cityName: widget.cityName,
              imageUrl: imageUrl, // Use imageUrl or default
            ),
          ),

          // Main Content Section
          SliverToBoxAdapter(
            child: CityContent(
              cityName: widget.cityName,
              cityId: widget.cityId,
            ),
          ),
        ],
      ),
    );
  }
}
