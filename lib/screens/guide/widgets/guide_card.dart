// guide_card.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  Future<void> _shareGuide(BuildContext context) async {
    try {
      String shareText =
          'Guide Name: $guideName\nDescription: $guideDescription\nPhone: $phoneNumber\nVehicle: $guidesVehicle';

      if (imageUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/guide_image.jpg');
          await file.writeAsBytes(response.bodyBytes);

          await Share.shareXFiles([XFile(file.path)], text: shareText);
        } else {
          await Share.share(shareText); // Share text only if image fails
        }
      } else {
        await Share.share(shareText); // Share text only if no image
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share guide: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _shareGuide(context),
      child: Card(
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
                        child:
                            imageUrl.isEmpty ? const Icon(Icons.person) : null,
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
      ),
    );
  }
}
