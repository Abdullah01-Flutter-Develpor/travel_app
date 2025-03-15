import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final String name;
  final String id;

  City({required this.name, required this.id});

  factory City.fromFirestore(DocumentSnapshot doc) {
    return City(
      id: doc.id,
      name: doc['name'],
    );
  }
}

class CityService {
  final CollectionReference _citiesRef =
      FirebaseFirestore.instance.collection('cities');

  Future<void> initializeCities() async {
    final snapshot = await _citiesRef.limit(1).get();
    if (snapshot.size == 0) {
      final defaultCities = [
        'Islamabad',
        'Lahore',
        'Peshawar',
        'Murree',
        'Gilgit',
        'Skardu',
        'Swat',
        'Chitral',
      ];
      for (final cityName in defaultCities) {
        await _citiesRef.add({'name': cityName});
      }
    }
  }

  Stream<List<City>> getCities() {
    return _citiesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => City.fromFirestore(doc)).toList());
  }
}
