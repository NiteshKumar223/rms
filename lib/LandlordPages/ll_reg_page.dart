import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rms/LandlordPages/ll_login_page.dart';
import 'package:rms/customui/custom_colors.dart';
import 'package:rms/customui/uihelper.dart';
import 'll_dashboard_page.dart';

class LandlordRegistrationPage extends StatefulWidget {
  const LandlordRegistrationPage({super.key});
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
      appBar: UiHelper.customAppbar("Landlord Registration"),
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
                  const SizedBox(height: 50),
                  UiHelper.CustomTextField(
                    llNameController,
                    "Name",
                    TextInputType.text,
                    validator: (value) {
                      String pattern = r'(^[a-zA-Z ]*$)';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return "Name is Required";
                      } else if (!regExp.hasMatch(value)) {
                        return "Name must be a-z and A-Z";
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
                      return "Mobile is Required";
                    } else if (value.length != 10) {
                      return "Mobile number must 10 digits";
                    } else if (!regExp.hasMatch(value)) {
                      return "Mobile Number must be in digits";
                    }
                    return null;
                  }),
                  UiHelper.customLoginSignupTextField(
                      llEmailController,
                      "Email",
                      false,
                      Icons.email,
                      TextInputType.emailAddress, validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = RegExp(pattern);
                    if (value == null || value.isEmpty) {
                      return "Email is Required";
                    } else if (!regExp.hasMatch(value)) {
                      return "Invalid Email";
                    } else {
                      return null;
                    }
                  }),
                  UiHelper.customLoginSignupTextField(
                      llPasswordController,
                      "Password",
                      true,
                      Icons.password,
                      TextInputType.visiblePassword, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    } else if (value.length < 6) {
                      return "Password must be longer than 6 characters";
                    }
                    return null;
                  }),
                  const SizedBox(height: 20),
                  UiHelper.CustomButton(
                    () {
                      if (_formKey.currentState?.validate() == true) {
                        register();
                      } else {
                        UiHelper.showsnackbar(
                            (context), "Something went wrong ?");
                      }
                    },
                    "Register",
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an Account  ",
                          style: TextStyle(fontSize: 16)),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LandlordLoginPage(),
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
