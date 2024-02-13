import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class MyImageSlider extends StatefulWidget {
  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  List<XFile>? _imageList = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  Future<void> _pickImages() async {
    final List<XFile>? pickedImages =
    await ImagePicker().pickMultiImage(imageQuality: 50);

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _imageList = pickedImages;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_imageList != null && _imageList!.isNotEmpty) {
      // Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImagesToStorage();

      // Save metadata (text fields and image URLs) to Firestore
      await _saveMetadataToFirestore(imageUrls);
    }
  }

  Future<List<String>> _uploadImagesToStorage() async {
    List<String> imageUrls = [];

    for (XFile image in _imageList!) {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await storageReference.putFile(file);

      // Get the download URL for each uploaded image
      String downloadURL = await storageReference.getDownloadURL();
      imageUrls.add(downloadURL);
    }

    return imageUrls;
  }

  Future<void> _saveMetadataToFirestore(List<String> imageUrls) async {
    // Create a Firestore document with metadata
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'address': _addressController.text,
      'state': _stateController.text,
      'imageUrls': imageUrls,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add the document to a 'images' collection
    await FirebaseFirestore.instance.collection('images').add(data);

    // Clear text field controllers and image list
    _nameController.clear();
    _addressController.clear();
    _stateController.clear();
    setState(() {
      _imageList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Slider with Upload'),
      ),
      body: Column(
        children: [
          if (_imageList != null && _imageList!.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                enlargeCenterPage: true,
              ),
              items: _imageList!.map((XFile image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Pick Images'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
          ),
          ElevatedButton(
            onPressed: _uploadImages,
            child: Text('Upload Images'),
          ),
        ],
      ),
    );
  }
}
