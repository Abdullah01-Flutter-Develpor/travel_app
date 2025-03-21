import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:travel_app/screens/guide/widgets/guide_card.dart';
import 'guide_addition_dialog.dart';

class GuideMainPageWidget extends StatelessWidget {
  final String cityId;

  const GuideMainPageWidget({Key? key, required this.cityId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cityId.isEmpty) {
      return Scaffold(
        body: Center(child: Text('Invalid city ID')),
      );
    }

    print('City ID: $cityId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Section',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cities')
            .doc(cityId)
            .collection('guides')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text(
                'No Guide yet!',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No guides found for cityId: $cityId');
            return Center(
                child: Text(
              'No guides available.',
            ));
          }

          final guideDocs = snapshot.data!.docs;
          print('Fetched ${guideDocs.length} guides for cityId: $cityId');
          for (final doc in guideDocs) {
            print('Guide: ${doc.data()}');
          }

          return ListView.builder(
            itemCount: guideDocs.length,
            itemBuilder: (context, index) {
              final guideData = guideDocs[index].data() as Map<String, dynamic>;
              return GuideCard(
                guideName: guideData['name'],
                guideDescription: guideData['description'],
                phoneNumber: guideData['phone'],
                guidesVehicle: guideData['vehicle'],
                imageUrl: guideData['image'],
                cityId: cityId,
                guideDocId: guideDocs[index].id,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => GuideAdditionDialog(cityId: cityId),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
