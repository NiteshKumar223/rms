import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rms/TenantPages/t_login_page.dart';

import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';
import 't_dashboard_page.dart';

class TenantRegistrationPage extends StatefulWidget {
  @override
  _TenantRegistrationPageState createState() => _TenantRegistrationPageState();
}

class _TenantRegistrationPageState extends State<TenantRegistrationPage> {
  final TextEditingController ll_uidController = TextEditingController();
  final TextEditingController tRoomNoController = TextEditingController();
  final TextEditingController tNameController = TextEditingController();
  final TextEditingController tMobController = TextEditingController();
  final TextEditingController tAddressController = TextEditingController();
  final TextEditingController tEmailController = TextEditingController();
  final TextEditingController tPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      // Perform tenant registration logic here
      // You may call a function to register the tenant with Firebase
      // Replace this with your actual Firebase registration logic

      // 1. Register the user with Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: tEmailController.text,
        password: tPasswordController.text,
      );

      // 2. Get the UID of the newly registered user
      String t_uid = FirebaseAuth.instance.currentUser!.uid;

      // 3. Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(t_uid).set({
        'type': 'tenant',
        'tRoomNo': tRoomNoController.text,
        'tName': tNameController.text,
        'tMobile': tMobController.text,
        'tAddress': tAddressController.text,
        'tEmail': tEmailController.text,
        'llUid': ll_uidController.text,
        'tUid': t_uid,
      });

      // 4. Navigate to TenantHomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TenantDashboardPage(tuid: t_uid),
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
      appBar: UiHelper.customAppbar("Tenant Registration"),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Ccolor.red,
          content: Text('Tap back again to leave'),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  UiHelper.CustomTextField(
                    ll_uidController,
                    "Landlord ID",
                    TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return UiHelper.CustomAlertBox((context),
                            "Landlord ID is must, which is provided by your landlord.");
                      }
                      return null;
                    },
                  ),
                  UiHelper.CustomTextField(
                    tRoomNoController,
                    "Room No.",
                    TextInputType.number,
                      validator: (value) {
                        String pattern = r'(^[0-9]*$)';
                        RegExp regExp = RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return UiHelper.CustomAlertBox((context), "Room number is Required");
                        } else if (!regExp.hasMatch(value)) {
                          return UiHelper.CustomAlertBox((context), "Room number must be in digits");
                        }
                        return null;
                      },
                  ),
                  UiHelper.CustomTextField(
                    tNameController,
                    "Name",
                    TextInputType.text,
                    validator: (value) {
                      String pattern = r'(^[a-zA-Z ]*$)';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return UiHelper.CustomAlertBox(
                            (context), "Name is Required");
                      } else if (!regExp.hasMatch(value)) {
                        return UiHelper.CustomAlertBox(
                            (context), "Name must be a-z and A-Z");
                      }
                      return null;
                    },
                  ),
                  UiHelper.CustomTextField(
                      tMobController, "Mobile No.", TextInputType.number,
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
                      }
                  ),
                  UiHelper.CustomTextField(tAddressController,
                      "Permanent Address", TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return UiHelper.CustomAlertBox(
                            (context), "Permanent address is Required");
                      }
                      return null;
                    },
                  ),
                  UiHelper.customLoginSignupTextField(tEmailController,
                      "Email Id", false, Icons.email, TextInputType.emailAddress,
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
                      tPasswordController,
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
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I don't have an Account  ",
                        style: TextStyle(fontSize: 16)),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TenantLoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Ccolor.primarycolor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
