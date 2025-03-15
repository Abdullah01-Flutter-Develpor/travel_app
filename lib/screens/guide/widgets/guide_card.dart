// guide_card.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuideCard extends StatelessWidget {
  const GuideCard({
    super.key,
    required this.guideName,
    required this.guideDescription,
    required this.phoneNumber,
    required this.guidesVehicle,
    required this.imageUrl,
    required this.cityId,
    required this.guideDocId,
  });

  final String guideName;
  final String guideDescription;
  final String phoneNumber;
  final String guidesVehicle;
  final String imageUrl;
  final String cityId;
  final String guideDocId;

  Future<void> _deleteGuide(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('cities')
          .doc(cityId)
          .collection('guides')
          .doc(guideDocId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete guide: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      guideName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteGuide(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              guideDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Call: $phoneNumber',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Vehicle: $guidesVehicle',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
