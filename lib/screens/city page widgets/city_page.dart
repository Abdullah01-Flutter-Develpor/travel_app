import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/l10n/app_localizations.dart';
import 'package:travel_app/l10n/traslates_city.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_app_bar.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_content.dart';
import 'package:travel_app/screens/city%20page%20widgets/city_page_header.dart';

class CityPage extends StatefulWidget {
  const CityPage({
    super.key,
    required this.cityName,
    required this.cityId,
  });

  final String cityName;
  final String cityId;

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;
  late String _imageUrl;
  Locale _locale = const Locale('en'); // Initialize locale

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _imageUrl = 'assets2/images/maria.jpg'; // Default image
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra != null && extra is String) {
      _imageUrl = extra;
    } else {
      print(AppLocalizations.of(context).noImageUrlProvidedUsingDefault);
    }
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

  void _updateLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Wrap with MaterialApp
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CityAppBar(
          cityName: widget.cityName,
          showTitle: _showAppBarTitle,
          onLocaleChanged: _updateLocale, // Pass _updateLocale
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: CityHeader(
                cityName: getTranslatedCityName(
                    context, widget.cityName), // Localized city name
                imageUrl: _imageUrl,
              ),
            ),

            // Main Content Section
            SliverToBoxAdapter(
              child: CityContent(
                cityName: getTranslatedCityName(
                    context, widget.cityName), // Localized city name
                cityId: widget.cityId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
