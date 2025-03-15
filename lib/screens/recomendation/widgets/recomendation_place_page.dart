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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
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
            ),
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
