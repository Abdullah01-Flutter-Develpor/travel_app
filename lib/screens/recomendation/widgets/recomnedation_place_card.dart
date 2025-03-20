// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // Import share_plus

class RecomendedPlaceCard extends StatelessWidget {
  const RecomendedPlaceCard({
    super.key,
    required this.recomendedPlaceName,
    required this.recomendedPlaceImage,
    required this.cityId,
    required this.recommendationDocId,
  });

  final String recomendedPlaceName;
  final String recomendedPlaceImage;
  final String cityId;
  final String recommendationDocId;

  Future<void> _deleteRecommendation(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('cities')
          .doc(cityId)
          .collection('recommendations')
          .doc(recommendationDocId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recommendation: $e')),
      );
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(recomendedPlaceImage));

      if (response.statusCode == 200) {
        if (kIsWeb) {
          // Handle web-specific sharing logic (e.g., using a data URL)
          Share.share(recomendedPlaceImage, subject: recomendedPlaceName);
        } else {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/image.jpg');
          await file.writeAsBytes(response.bodyBytes);

          await Share.shareXFiles([XFile(file.path)],
              subject: recomendedPlaceName);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate card dimensions based on screen size
    final cardWidth = screenWidth * 0.9; // 90% of screen width
    final cardHeight = screenHeight * 0.25; // 25% of screen height

    return GestureDetector(
      onLongPress: () => _shareImage(context), // Share on long press
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with gradient overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  recomendedPlaceImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Place name and delete button
              Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.03), // Responsive padding
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place name
                      Flexible(
                        child: Text(
                          recomendedPlaceName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                            fontWeight: FontWeight.w600,
                            shadows: const [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          maxLines: 2, // Allow text to wrap to 2 lines
                          overflow: TextOverflow.ellipsis, // Truncate if needed
                        ),
                      ),
                      // Delete button
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          iconSize: screenWidth * 0.06, // Responsive icon size
                          onPressed: () => _deleteRecommendation(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
