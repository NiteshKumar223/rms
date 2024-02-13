import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rms/customui/uihelper.dart';

import '../customui/custom_colors.dart';
import 'll_dashboard_page.dart';

class LandlordRegistrationPage extends StatefulWidget {
  @override
  _LandlordRegistrationPageState createState() =>
      _LandlordRegistrationPageState();
}

class _LandlordRegistrationPageState extends State<LandlordRegistrationPage> {
  final TextEditingController llNameController = TextEditingController();
  final TextEditingController llMobController = TextEditingController();
  final TextEditingController llEmailController = TextEditingController();
  final TextEditingController llPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      // 1. Register the user with Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: llEmailController.text, password: llPasswordController.text);

      // 2. Get the UID of the newly registered user
      String ll_uid = FirebaseAuth.instance.currentUser!.uid;

      // 3. Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(ll_uid).set({
        'type': 'landlord',
        'llName': llNameController.text,
        'llMob': llMobController.text,
        'llEmail': llEmailController.text,
        'llUid': ll_uid,
      });

      // 4. Navigate to LandlordHomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandlordDashboardPage(lluid: ll_uid),
        ),
      );
    } catch (e) {
      // Handle registration errors
      UiHelper.CustomAlertBox(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor.primarycolor,
        title: Text("Landlord Registration",
            style: TextStyle(
                fontSize: 21,
                color: Ccolor.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                UiHelper.CustomTextField(
                    llNameController, "Name", TextInputType.text,
                    validator: (value) {
                      String pattern = r'(^[a-zA-Z ]*$)';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return UiHelper.CustomAlertBox((context), "Name is Required");
                      } else if (!regExp.hasMatch(value)) {
                        return UiHelper.CustomAlertBox((context), "Name must be a-z and A-Z");
                      }
                      return null;
                    },
                ),
                UiHelper.CustomTextField(
                    llMobController, "Mobile No.", TextInputType.number,
                    validator: (value) {
                  String pattern = r'(^[0-9]*$)';
                  RegExp regExp = RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return UiHelper.CustomAlertBox((context), "Mobile is Required");
                  } else if (value.length != 10) {
                    return UiHelper.CustomAlertBox((context), "Mobile number must 10 digits");
                  } else if (!regExp.hasMatch(value)) {
                    return UiHelper.CustomAlertBox((context), "Mobile Number must be in digits");
                  }
                  return null;
                }),
                UiHelper.customLoginSignupTextField(llEmailController, "Email",
                    false, Icons.email, TextInputType.emailAddress,
                    validator: (value){
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return UiHelper.CustomAlertBox((context), "Email is Required");
                      } else if (!regExp.hasMatch(value)) {
                        return UiHelper.CustomAlertBox((context), "Invalid Email");
                      } else {
                        return null;
                      }
                    }
                ),
                UiHelper.customLoginSignupTextField(
                    llPasswordController,
                    "Password",
                    true,
                    Icons.password,
                    TextInputType.visiblePassword,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return UiHelper.CustomAlertBox((context), "Password can't be empty");
                      } else if (value.length < 6){
                        return UiHelper.CustomAlertBox((context), "Password must be longer than 6 characters");
                      }
                      return null;
                    }
                ),
                const SizedBox(height: 20),
                UiHelper.CustomButton(
                  () {
                      if (_formKey.currentState?.validate() == true) {
                        register();
                      } else {
                        UiHelper.CustomAlertBox((context), "Something went wrong ?");
                      }
                  },
                  "Register",
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
