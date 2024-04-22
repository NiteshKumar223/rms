import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rms/customui/check_slider.dart';

import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class LandlordAddRoomPage extends StatefulWidget {
  final int currindex;
  const LandlordAddRoomPage({super.key, required this.currindex});

  @override
  State<LandlordAddRoomPage> createState() => _LandlordAddRoomPageState();
}

class _LandlordAddRoomPageState extends State<LandlordAddRoomPage> {
  File? pickedImage;
  final TextEditingController roomRentCtr = TextEditingController();
  final TextEditingController buildingNameCtr = TextEditingController();
  final TextEditingController noOfRoomAvlCtr = TextEditingController();
  final List<String> furnishing = ["No", "Half Furnished", "Fully Furnished"];
  final List<String> availableFor = [
    "Only Girls",
    "Only Boys",
    "Students",
    "Family"
  ];
  final List<String> parking = ["Not Available", "Two Wheeler", "Four Wheeler"];
  final TextEditingController descAboutRoomCtr = TextEditingController();
  final TextEditingController nearbyAddressCtr = TextEditingController();
  final TextEditingController fullAddressCtr = TextEditingController();
  final TextEditingController ownerMobileCtr = TextEditingController();

  String? selectedFurnishing;
  String? selectedAvailableFor;
  String? selectedParking;
  DateTime today = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<XFile>? _imageList = [];

  Future<void> pickImages() async {
    final List<XFile>? pickedImages =
        await ImagePicker().pickMultiImage(imageQuality: 50);

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _imageList = pickedImages;
      });
    }
  }

  Future<void> uploadAvailableRooms() async {
    if (_imageList != null && _imageList!.isNotEmpty) {
      // Upload images to Firebase Storage
      List<String> imageUrls = await uploadImagesToStorage();

      // Save metadata (text fields and image URLs) to Firestore
      await saveMetadataToFirestore(imageUrls);
    }
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> imageUrls = [];

    for (XFile image in _imageList!) {
      File file = File(image.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("rooms_images")
          .child(fileName)
          .putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(downloadURL);
    }
    return imageUrls;
  }

  Future<void> saveMetadataToFirestore(List<String> imageUrls) async {
    // Create a Firestore document with metadata
    FirebaseAuth llInstance = FirebaseAuth.instance;
    User? user = llInstance.currentUser;
    if (user != null) {
      String lluid = user.uid;
      FirebaseFirestore.instance.collection("rooms_available").add({
        'aImageUrls': imageUrls,
        'bRoomRent': roomRentCtr.text,
        'bRoomAvl': noOfRoomAvlCtr.text.trim(),
        'cBuilding': buildingNameCtr.text,
        'dFurniture': selectedFurnishing,
        'eAvailability': selectedAvailableFor,
        'fParking': selectedParking,
        'gDescription': descAboutRoomCtr.text,
        'hNearbyAddress': nearbyAddressCtr.text,
        'iFullAddress': fullAddressCtr.text,
        'jOwnerMobile': ownerMobileCtr.text,
        'llUid': lluid,
        'listingDate': today,
      }).then((value) {
        ProgressDialog.hide(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                title: Text("Room Listing Successfully",
                    style: TextStyle(fontSize: 16, color: Ccolor.red)),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Ccolor.primarycolor,
                    ),
                    onPressed: () {
                      ProgressDialog.hide(context);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(fontSize: 20, color: Ccolor.white),
                    ),
                  ),
                ],
              );
            });
        // setState(() {
        //    widget.currindex;
        // });
      });
    } else {
      UiHelper.CustomAlertBox(context, "User not found");
    }
    // Clear text field controllers and image list
    roomRentCtr.clear();
    buildingNameCtr.clear();
    noOfRoomAvlCtr.clear();
    descAboutRoomCtr.clear();
    nearbyAddressCtr.clear();
    fullAddressCtr.clear();
    ownerMobileCtr.clear();
    setState(() {
      _imageList = [];
      selectedFurnishing = null;
      selectedAvailableFor = null;
      selectedParking = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Ccolor.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 320,
                  width: MediaQuery.of(context).size.width - 35,
                  decoration: BoxDecoration(
                    color: Ccolor.white,
                    border: Border.all(color: Ccolor.primarycolor, width: 2),
                    // borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      // here in this column i want to pick image from gallery
                      if (_imageList != null && _imageList!.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 315.0,
                            // enlargeCenterPage: true,
                          ),
                          items: _imageList!.map((XFile image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  height: 315,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Image.file(
                                    File(image.path),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    onPressed: () => pickImages(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pick from Gallery"),
                        Icon(Icons.image),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                UiHelper.CustomTextField(
                  roomRentCtr,
                  "Room Rent",
                  TextInputType.number,
                  validator: (value) {
                    String pattern = r'(^[0-9]*$)';
                    RegExp regExp = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Total Rent is required");
                    } else if (!regExp.hasMatch(value)) {
                      return UiHelper.CustomAlertBox(
                          (context), "Total Rent must be in digits");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomTextField(
                  buildingNameCtr,
                  "Building Name",
                  TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Building name is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomTextField(
                  noOfRoomAvlCtr,
                  "Number of room available",
                  TextInputType.number,
                  validator: (value) {
                    String pattern = r'(^[0-9]*$)';
                    RegExp regExp = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Available room is required");
                    } else if (!regExp.hasMatch(value)) {
                      return UiHelper.CustomAlertBox(
                          (context), "Available room must be in digits");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomDropdown(
                  items: furnishing,
                  hintText: 'Select Furniture Type',
                  onChanged: (value) {
                    setState(() {
                      selectedFurnishing = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Furniture selection is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomDropdown(
                  items: availableFor,
                  hintText: 'Select Room Available For',
                  onChanged: (value) {
                    setState(() {
                      selectedAvailableFor = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Availability selection is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomDropdown(
                  items: parking,
                  hintText: 'Select Parking Type',
                  onChanged: (value) {
                    setState(() {
                      selectedParking = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Parking selection is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomTextField(
                  descAboutRoomCtr,
                  "Description About Room",
                  TextInputType.text,
                  isMultiline: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Description is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomTextField(
                  nearbyAddressCtr,
                  "Nearby Address",
                  TextInputType.text,
                  isMultiline: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Nearby address is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomTextField(
                  fullAddressCtr,
                  "Full Address",
                  TextInputType.text,
                  isMultiline: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Full address is Required");
                    }
                    return null;
                  },
                ),
                UiHelper.CustomTextField(
                  ownerMobileCtr,
                  "Owner Mobile Number",
                  TextInputType.number,
                  validator: (value) {
                    String pattern = r'(^[0-9]*$)';
                    RegExp regExp = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return UiHelper.CustomAlertBox(
                          (context), "Mobile number is required");
                    } else if (value.length != 10) {
                      return UiHelper.CustomAlertBox(
                          (context), "Mobile number must be in 10 digits");
                    } else if (!regExp.hasMatch(value)) {
                      return UiHelper.CustomAlertBox(
                          (context), "Mobile number must be in digits");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                UiHelper.CustomButton(() async {
                  if (_formKey.currentState?.validate() == true) {
                    uploadAvailableRooms();
                    ProgressDialog.show(context);

                    // Simulate an asynchronous operation, such as uploading data to Firebase
                    await Future.delayed(Duration(seconds: 7));

                    // Once the operation is complete, hide the dialog
                    ProgressDialog.hide(context);
                  } else {
                    UiHelper.CustomAlertBox(
                        (context), "Something went wrong ?");
                  }
                }, "Submit"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Set to true if you want users to be able to dismiss the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
