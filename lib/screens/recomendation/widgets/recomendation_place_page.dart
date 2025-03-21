import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/screens/recomendation/widgets/recomendation_addition_dialog.dart';
import 'package:travel_app/screens/recomendation/widgets/recomnedation_place_card.dart';

class RecomendationPlacesPage extends StatelessWidget {
  final String cityId;

  const RecomendationPlacesPage({Key? key, required this.cityId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Places'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cities')
            .doc(cityId)
            .collection('recommendations')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recommendationDocs = snapshot.data!.docs;

          if (recommendationDocs.isEmpty) {
            return const Center(
              child: Text(
                'No recommendations yet!',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 16.0, // Horizontal space between items
              mainAxisSpacing: 16.0, // Vertical space between items
              childAspectRatio: 0.8, // Aspect ratio of each card
            ),
            itemCount: recommendationDocs.length,
            itemBuilder: (context, index) {
              final recommendationData =
                  recommendationDocs[index].data() as Map<String, dynamic>;

              return RecomendedPlaceCard(
                recomendedPlaceName: recommendationData['name'],
                recomendedPlaceImage: recommendationData['image'],
                cityId: cityId,
                recommendationDocId: recommendationDocs[index].id,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => RecommendationAdditionDialog(cityId: cityId),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
