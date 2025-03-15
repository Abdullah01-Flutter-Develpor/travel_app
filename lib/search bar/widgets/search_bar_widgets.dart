import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/routers/route_path_class.dart';

class City {
  final String id;
  final String name;

  City({required this.id, required this.name});
}

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late SearchController _searchController;

  final List<City> _cities = [
    City(id: '1', name: 'Islamabad'),
    City(id: '2', name: 'Lahore'),
    City(id: '3', name: 'Peshawar'),
    City(id: '4', name: 'Murree'),
    City(id: '5', name: 'Gilgit'),
    City(id: '6', name: 'Skardu'),
    City(id: '7', name: 'Swat'),
    City(id: '8', name: 'Chitral'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = SearchController(); // Initialize the SearchController
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the SearchController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView(); // Open the search view
          },
          onChanged: (query) {
            controller.openView(); // Open the search view when typing
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
              // Navigate to the city route using path parameters
              context.go(
                '/${RoutePathClass.pathCity}/${city.name}/${city.id}',
              );

              // Close the search view and clear the search bar
              controller.closeView(city.name);
              _searchController.clear();
            },
          );
        });
      },
    );
  }
}
