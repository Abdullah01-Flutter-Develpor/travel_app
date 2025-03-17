// search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class City {
  final String id;
  final String name;
  final String imageUrl;

  City({required this.id, required this.name, required this.imageUrl});
}

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late SearchController _searchController;

  final List<City> _cities = [
    City(id: '1', name: 'Islamabad', imageUrl: 'assets2/images/islamabad.jpeg'),
    City(id: '2', name: 'Lahore', imageUrl: 'assets2/images/lahore.jpeg'),
    City(id: '3', name: 'Peshawar', imageUrl: 'assets2/images/peshawar.jpeg'),
    City(id: '4', name: 'Murree', imageUrl: 'assets2/images/murree.jpeg'),
    City(id: '5', name: 'Gilgit', imageUrl: 'assets2/images/gilgit.jpeg'),
    City(id: '6', name: 'Skardu', imageUrl: 'assets2/images/skardu.jpeg'),
    City(id: '7', name: 'Swat', imageUrl: 'assets2/images/swat.jpeg'),
    City(id: '8', name: 'Chitral', imageUrl: 'assets2/images/chitral.jpeg'),
    City(id: '9', name: 'Hunza', imageUrl: 'assets2/images/ hunzariver.jpeg'),
    City(id: '10', name: 'Kumrat', imageUrl: 'assets2/images/kumraat.jpeg'),
    City(
        id: '11',
        name: 'Kelash Valley',
        imageUrl: 'assets2/images/kalash.jpeg'),
    City(
        id: '12',
        name: 'Jahaz Banda',
        imageUrl: 'assets2/images/jahabanda.jpeg'),
    City(id: '14', name: 'Tirah Valley', imageUrl: 'assets2/images/tirah.jpeg'),
    City(id: '15', name: 'Kashmir', imageUrl: 'assets2/images/kashmir.jpeg'),
    City(
        id: '16',
        name: 'Neelum Valley',
        imageUrl: 'assets2/images/neelum.jpeg'),
    City(id: '17', name: 'Kel', imageUrl: 'assets2/images/kel.jpeg'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    print('SearchBarWidget initialized');
  }

  @override
  void dispose() {
    print('SearchBarWidget disposed');
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (query) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: 'Search for a city...',
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.value.text.toLowerCase();
        final filteredCities = query.isEmpty
            ? _cities
            : _cities
                .where((city) => city.name.toLowerCase().contains(query))
                .toList();

        return List<ListTile>.generate(filteredCities.length, (index) {
          final city = filteredCities[index];
          return ListTile(
            title: Text(city.name),
            onTap: () {
              context.go(
                '/${RoutePathClass.pathCity}/${city.name}/${city.id}',
                extra: city.imageUrl,
              );
              controller.closeView(city.name);
              Future.delayed(Duration.zero, () {
                _searchController.clear();
              });
            },
          );
        });
      },
    );
  }
}

class RoutePathClass {
  static const String pathCity =
      'city'; // Assuming you have a route named 'city'
}
