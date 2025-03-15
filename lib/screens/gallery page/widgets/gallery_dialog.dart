import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagePickerDialog extends StatefulWidget {
  final String cityId; // Add cityId parameter

  const ImagePickerDialog({super.key, required this.cityId});

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) setState(() => _imageFile = image);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null || _nameController.text.isEmpty) return;

    setState(() => _isUploading = true);
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('gallery/${DateTime.now().millisecondsSinceEpoch}');

      await storageRef.putFile(File(_imageFile!.path));
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('cities')
          .doc(widget.cityId) // Use cityId to save image
          .collection('gallery')
          .add({
        'imageUrl': imageUrl,
        'imageName': _nameController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text('Add New Image'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Image Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Selected: ${_imageFile!.name}',
                    style: TextStyle(color: Colors.grey.shade600)),
              ),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: _isUploading ? null : () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: _isUploading ? null : _uploadImage,
            child: const Text('Upload')),
      ],
    );
  }
}
