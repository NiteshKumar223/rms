import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rms/customui/uihelper.dart';
import '../customui/custom_colors.dart';

class LandlordPricingPage extends StatefulWidget {
  const LandlordPricingPage({super.key});

  @override
  State<LandlordPricingPage> createState() => _LandlordPricingPageState();
}

class _LandlordPricingPageState extends State<LandlordPricingPage> {
  final TextEditingController elePerUnitController = TextEditingController();
  final TextEditingController roomRentController = TextEditingController();
  final TextEditingController btCleaningChargeController =
  TextEditingController();
  final TextEditingController waterChargeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? pickedImage;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String imageUrl;
  late String elePerUnit;
  late String roomRent;
  late String btCleaningCharge;
  late String waterCharge;

  @override
  void initState() {
    super.initState();
    imageUrl =
    "https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1703520381~exp=1703520981~hmac=fda9b147134991e9028f877ef241a1d2bed69d739686dbed5fcbbdff08d6d09a";
    elePerUnit = "Loading...";
    roomRent = "Loading...";
    btCleaningCharge = "Loading...";
    waterCharge = "Loading...";
    llPricingData();
  }

  Future<String?> getCurrentUserUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      return uid;
    } else {
      print('No user is currently logged in.');
      return null;
    }
  }

  Future<void> llPricingData() async {
    String? user = await getCurrentUserUid();
    try {
      DocumentSnapshot<Map<String, dynamic>> pricingData =
      await FirebaseFirestore.instance.collection('pricing_data').doc(user).get();
      setState(() {
        imageUrl = pricingData['qrUrl'];
        elePerUnit = pricingData['eleCostPerUnit'];
        roomRent = pricingData['costPerRoom'];
        btCleaningCharge = pricingData['tbCleanPerMonth'];
        waterCharge = pricingData['waterPerMonth'];
      });
    } catch (e) {
      print('Error loading user data: $e');
      UiHelper.CustomAlertBox(
          context, "loading user data: Failed ! Try after sometime");
      setState(() {
        imageUrl =
        "https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1703520381~exp=1703520981~hmac=fda9b147134991e9028f877ef241a1d2bed69d739686dbed5fcbbdff08d6d09a";
        elePerUnit = "Loading...";
        roomRent = "Loading...";
        btCleaningCharge = "Loading...";
        waterCharge = "Loading...";
      });
    }
  }

  Future<bool> hasUserUploadedImage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('pricing_data').doc(user.uid).get();
      return snapshot.exists;
    }
    return false;
  }

  void uploadPricing() async {
    User? user = _auth.currentUser;
    if (user != null) {
      if (await hasUserUploadedImage()) {
        UiHelper.CustomAlertBox(
            context,
            "Landlord can upload pricing only once if you want to change your pricing then you need to update by clicking on update button");
      } else {
        try {
          String? llUid = user.uid;
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("upi_qr")
              .child(llUid.toString())
              .putFile(pickedImage!);
          TaskSnapshot taskSnapshot = await uploadTask;
          String qr_url = await taskSnapshot.ref.getDownloadURL();
          FirebaseFirestore.instance.collection("pricing_data").doc(llUid).set({
            'qrUrl': qr_url,
            'eleCostPerUnit': elePerUnitController.text.toString(),
            'costPerRoom': roomRentController.text.toString(),
            'tbCleanPerMonth': btCleaningChargeController.text.toString(),
            'waterPerMonth': waterChargeController.text.toString(),
            'llUid': llUid,
          }).then((value) {
            UiHelper.CustomAlertBox(context, "Pricing uploaded successfully");
          });
          elePerUnitController.clear();
          roomRentController.clear();
          btCleaningChargeController.clear();
          waterChargeController.clear();
          setState(() {
            pickedImage = null;
          });
        } on FirebaseException catch (ex) {
          UiHelper.CustomAlertBox(context, "Something went wrong in Database");
          debugPrint(ex.toString());
        }
      }
    }
  }

  void updateData() async {
    try {
      User? user = _auth.currentUser;
      String? llUid = user?.uid;

      // Fetch the existing data from Firestore
      DocumentSnapshot<Map<String, dynamic>> pricingData =
      await FirebaseFirestore.instance.collection('pricing_data').doc(llUid).get();

      // Set the existing data in the text fields
      elePerUnitController.text = pricingData['eleCostPerUnit'];
      roomRentController.text = pricingData['costPerRoom'];
      btCleaningChargeController.text = pricingData['tbCleanPerMonth'];
      waterChargeController.text = pricingData['waterPerMonth'];

      // Show the image picker with the existing image
      pickImageFromUrl(pricingData['qrUrl']);

      // Optionally, you can also display a confirmation message
      UiHelper.CustomAlertBox(context, "Data loaded for update");

    } on FirebaseException catch (ex) {
      UiHelper.CustomAlertBox(context, "Something went wrong in Database");
      debugPrint(ex.toString());
    }
  }

  Future<void> actualUpdateData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        String llUid = user.uid;

        if (pickedImage != null) {
          // If a new image is selected, upload it
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("upi_qr")
              .child(llUid)
              .putFile(pickedImage!);
          TaskSnapshot taskSnapshot = await uploadTask;
          String qr_url = await taskSnapshot.ref.getDownloadURL();

          // Update the image URL in Firestore
          await FirebaseFirestore.instance
              .collection("pricing_data")
              .doc(llUid)
              .update({'qrUrl': qr_url});
        }

        // Update other fields in Firestore
        await FirebaseFirestore.instance.collection("pricing_data").doc(llUid).update({
          'eleCostPerUnit': elePerUnitController.text,
          'costPerRoom': roomRentController.text,
          'tbCleanPerMonth': btCleaningChargeController.text,
          'waterPerMonth': waterChargeController.text,
        });

        UiHelper.CustomAlertBox(context, "Pricing updated successfully");

        // Clear the text fields and reset the pickedImage state
        elePerUnitController.clear();
        roomRentController.clear();
        btCleaningChargeController.clear();
        waterChargeController.clear();
        setState(() {
          pickedImage = null;
        });
      } catch (ex) {
        UiHelper.CustomAlertBox(context, "Something went wrong: ${ex.toString()}");
      }
    }
  }

  void pickImageFromUrl(String imageUrl) async {
    try {
      // Download the image from the provided URL
      final response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;

      setState(() {
        pickedImage = File.fromRawPath(bytes);
      });
    } catch (ex) {
      UiHelper.CustomAlertBox(context, "Something went wrong: ${ex.toString()}");
    }
  }



  void showAlertBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick Image From"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.customAppbar("Landlord Pricing"),
      body: Container(
        padding: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showAlertBox();
                  },
                  child: Container(
                    height: 320,
                    width: MediaQuery.of(context).size.width - 34,
                    decoration: BoxDecoration(
                      color: Ccolor.white,
                      border: Border.all(color: Ccolor.primarycolor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 270,
                          width: MediaQuery.of(context).size.width,
                          child: pickedImage != null
                              ? Image.file(pickedImage!)
                              : Icon(Icons.qr_code, color: Ccolor.grey, size: 250),
                        ),
                        Divider(color: Ccolor.primarycolor, thickness: 2),
                        const Text(
                          "Tap to upload your QR to receive Payment",
                        style: TextStyle(fontSize: 12)
                        ),
                      ],
                    ),
                  ),
                ),
                UiHelper.CustomTextField(
                    elePerUnitController,
                    "Electricity Cost/Unit",
                    TextInputType.number, validator: (value) {
                  String pattern = r'(^[0-9]*$)';
                  RegExp regExp = RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return UiHelper.CustomAlertBox(
                        (context), "Electricity Price is Required");
                  } else if (!regExp.hasMatch(value)) {
                    return UiHelper.CustomAlertBox(
                        (context), "Electricity Price must be in digits");
                  }
                  return null;
                }),
                UiHelper.CustomTextField(
                    roomRentController, "Rent Cost/Room", TextInputType.number,
                    validator: (value) {
                      String pattern = r'(^[0-9]*$)';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return UiHelper.CustomAlertBox(
                            (context), "Rent Price is Required");
                      } else if (!regExp.hasMatch(value)) {
                        return UiHelper.CustomAlertBox(
                            (context), "Rent Price must be in digits");
                      }
                      return null;
                    }),
                UiHelper.CustomTextField(
                    btCleaningChargeController,
                    "Toilet/Bathroom cleaning/month",
                    TextInputType.number, validator: (value) {
                  String pattern = r'(^[0-9]*$)';
                  RegExp regExp = RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return UiHelper.CustomAlertBox(
                        (context), "Cleaning Price is Required");
                  } else if (!regExp.hasMatch(value)) {
                    return UiHelper.CustomAlertBox(
                        (context), "Cleaning Price must be in digits");
                  }
                  return null;
                }),
                UiHelper.CustomTextField(
                    waterChargeController,
                    "Water Cost/month",
                    TextInputType.number, validator: (value) {
                  String pattern = r'(^[0-9]*$)';
                  RegExp regExp = RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return UiHelper.CustomAlertBox(
                        (context), "Water Price is Required");
                  } else if (!regExp.hasMatch(value)) {
                    return UiHelper.CustomAlertBox(
                        (context), "Water Price must be in digits");
                  }
                  return null;
                }),
                UiHelper.CustomButton(() {
                  if (_formKey.currentState?.validate() == true) {
                    uploadPricing();
                  } else {
                    UiHelper.CustomAlertBox(
                        (context), "Something went wrong ?");
                  }
                }, "Submit Price"),
                const SizedBox(height: 20),
                UiHelper.CustomButton(() {
                  if (_formKey.currentState?.validate() == true) {
                    // Call function to perform the actual update on the server
                    actualUpdateData();
                  } else {
                    UiHelper.CustomAlertBox(context, "Something went wrong?");
                  }
                }, "Update Price"),
                const SizedBox(height: 50),
                Container(
                  height: 510,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Ccolor.white,
                    border: Border.all(color: Ccolor.primarycolor, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 320,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(imageUrl),
                      ),
                      Divider(color: Ccolor.primarycolor, thickness: 2),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              UiHelper.customRowData(
                                  "Electricity/Unit Rs:", elePerUnit),
                              const SizedBox(height: 10),
                              UiHelper.customRowData("Rent/Room Rs:", roomRent),
                              const SizedBox(height: 10),
                              UiHelper.customRowData(
                                  "Toilet/Bathroom Cleaning Rs:", btCleaningCharge),
                              const SizedBox(height: 10),
                              UiHelper.customRowData(
                                  "Water Charge Rs:", waterCharge),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                UiHelper.CustomButton(() {
                  updateData();
                }, "Fatch Updated Price"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      UiHelper.CustomAlertBox(
          context, "Something went wrong: ${ex.toString()}");
    }
  }
}