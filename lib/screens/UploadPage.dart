// ignore_for_file: unused_field

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_app/component/app_button.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/text_field.dart';
import 'package:travel_app/control_room/firebase_reference.dart';
import 'package:travel_app/uitlity/Utils.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<File> images = [];
  List<MediaModel> imagess = <MediaModel>[];

  List<File> _imageFiles = [];
  String? _name;
  String? _description;
  String? _weather;
  double? _latitude;
  double? _longitude;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController weatherController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  final picker = ImagePicker();

  bool loading = false;

  Widget Space(double? height) {
    return SizedBox(
      height: height,
    );
  }

  storeEntry(
    List<String> imageUrls,
  ) {
    setState(() {
      loading = true;
    });
    FirebaseReference().travelPost.add({
      'imageurl': imageUrls,
      'name': _nameController.text,
      'description': _descriptionController.text,
      'latitude': latitudeController.text.toString(),
      'longitude': longitudeController.text.toString(),
      'weather': weatherController.text.toString(),
    }).then((value) {
      value.update({'id': value.id.toString()}).then((value) {
        setState(() {
          loading = false;
        });
        Utils.toastMessage("Product Add Successful", context);
        Get.back();
      });
    });
  }

  List<String> downloadUrls = [];
  final ImagePicker _picker = ImagePicker();
  getMultipImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage(
      imageQuality: 100, // Ensure maximum quality
      maxWidth: 1920, // HD resolution width
      maxHeight: 1080,
    );

    if (pickedImages != null) {
      pickedImages.forEach((e) {
        images.add(File(e.path));
      });

      setState(() {});
    }
  }

  Future<String> uploadFile(File file) async {
    setState(() {
      loading = true;
    });

    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = FirebaseStorage.instance.ref();
    Reference ref = storageRef
        .child('pictures/${DateTime.now().microsecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(file, metaData);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteColor,
      appBar: AppBar(
        title: Text('Upload Images'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: 150,
                child: images.isEmpty
                    ? Icon(
                        Icons.upload_file,
                        size: 80,
                        color: appColors.blueColor,
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return Stack(
                            children: [
                              Container(
                                  width: 100,
                                  margin: EdgeInsets.only(right: 10),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Image.file(
                                      filterQuality: FilterQuality.high,
                                      images[i],
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          );
                        },
                        itemCount: images.length,
                      ),
              ),
              ElevatedButton(
                onPressed: getMultipImage,
                child: Text('Choose Images'),
              ),
              customTextField(
                obscureText: false,
                labelText: "Name",
                Controller: _nameController,
              ),
              SizedBox(
                height: 10,
              ),
              customTextField(
                obscureText: false,
                labelText: "Description",
                Controller: _descriptionController,
              ),
              SizedBox(
                height: 10,
              ),
              customTextField(
                obscureText: false,
                labelText: "Weather",
                Controller: weatherController,
              ),
              SizedBox(
                height: 10,
              ),
              customTextField(
                obscureText: false,
                labelText: "Latitude",
                Controller: latitudeController,
              ),
              SizedBox(
                height: 10,
              ),
              customTextField(
                obscureText: false,
                labelText: "Longitude",
                Controller: longitudeController,
              ),
              SizedBox(
                height: 25,
              ),
              appButton(
                onPressed: () async {
                  for (int i = 0; i < images.length; i++) {
                    String url = await uploadFile(images[i]);
                    downloadUrls.add(url);
                    if (i == images.length - 1) {
                      storeEntry(
                        downloadUrls,
                      );
                    } else {
                      print("Completed >>>>>>>>>>>>>>>");
                    }
                  }
                },
                title: "Submit",
                loading: loading,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MediaModel {
  File file;
  String filePath;
  Uint8List blobImage;
  MediaModel.blob(this.file, this.filePath, this.blobImage);
}
