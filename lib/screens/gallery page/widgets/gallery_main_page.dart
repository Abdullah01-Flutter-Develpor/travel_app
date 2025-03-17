import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:travel_app/screens/gallery%20page/widgets/gallery_dialog.dart';
import 'package:travel_app/screens/gallery%20page/widgets/image_card_with_delete.dart';

import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class GalleryPage extends StatefulWidget {
  final String cityId;

  const GalleryPage({super.key, required this.cityId});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteImage(String docId, String imageUrl) async {
    try {
      await _firestore
          .collection('cities')
          .doc(widget.cityId)
          .collection('gallery')
          .doc(docId)
          .delete();

      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting image: $e')),
      );
    }
  }

  Future<void> _shareImage(String imageUrl, String imageName) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/image.jpg');
        await file.writeAsBytes(response.bodyBytes);

        await Share.shareXFiles([XFile(file.path)], subject: imageName);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 4.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('cities')
            .doc(widget.cityId)
            .collection('gallery')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          }

          return StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.docs.length,
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return GestureDetector(
                onLongPress: () =>
                    _shareImage(data['imageUrl'], data['imageName']),
                child: ImageCardWithDelete(
                  imageUrl: data['imageUrl'],
                  imageName: data['imageName'],
                  onDelete: () => _deleteImage(doc.id, data['imageUrl']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => ImagePickerDialog(cityId: widget.cityId),
        ),
        child: const Icon(Icons.add_a_photo, color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 4.0,
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        itemCount: 6,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        itemBuilder: (context, index) {
          return Container(
            height: 250, // Increased height for shimmer effect
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
