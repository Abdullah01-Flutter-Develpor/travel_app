import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/screens/hotels/widgets/add_hotel_dialog.dart';
import 'package:travel_app/screens/hotels/widgets/hotel_card_delet.dart';
import 'package:travel_app/screens/hotels/widgets/model_class.dart/model_class.dart';

class HotelMainPage extends StatefulWidget {
  final String cityId; // Add cityId parameter

  const HotelMainPage({super.key, required this.cityId});

  @override
  State<HotelMainPage> createState() => _HotelMainPageState();
}

class _HotelMainPageState extends State<HotelMainPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> _deletingIds = {};

  Future<void> _addHotel(Hotel hotel) async {
    try {
      final docRef = _firestore
          .collection('cities')
          .doc(widget.cityId) // Use cityId to add hotel
          .collection('hotels')
          .doc();
      await docRef.set({
        'hotelName': hotel.hotelName,
        'hotelAddress': hotel.hotelAddress,
        'hotelPerNightStay': hotel.hotelPerNightStay,
        'hotelImage': hotel.hotelImage,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding hotel: $e')),
      );
    }
  }

  Future<void> _deleteHotel(String docId, String imageUrl) async {
    setState(() => _deletingIds.add(docId));
    try {
      await _firestore
          .collection('cities')
          .doc(widget.cityId) // Use cityId to delete hotel
          .collection('hotels')
          .doc(docId)
          .delete();
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting hotel: $e')),
      );
    } finally {
      setState(() => _deletingIds.remove(docId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('cities')
              .doc(widget.cityId) // Fetch hotels for the specific city
              .collection('hotels')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final hotels = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Hotel(
                hotelName: data['hotelName'] ?? '',
                hotelAddress: data['hotelAddress'] ?? '',
                hotelPerNightStay:
                    (data['hotelPerNightStay'] as num).toDouble(),
                hotelImage: data['hotelImage'] ?? '',
              );
            }).toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 400,
              ),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                final doc = snapshot.data!.docs[index];
                final isDeleting = _deletingIds.contains(doc.id);

                return HotelCardWithDelete(
                  hotel: hotel,
                  onDelete: () => _deleteHotel(doc.id, hotel.hotelImage),
                  isDeleting: isDeleting,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddHotelDialog(onHotelAdded: _addHotel),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
