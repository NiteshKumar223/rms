import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rms/TenantPages/t_dashboard_page.dart';
import 'package:rms/TenantPages/t_reg_page.dart';

import '../CommonPages/forgot_password.dart';
import '../LandlordPages/ll_dashboard_page.dart';
import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class TenantLoginPage extends StatefulWidget {
  @override
  _TenantLoginPageState createState() => _TenantLoginPageState();
}

class _TenantLoginPageState extends State<TenantLoginPage> {

  // start
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _loginUser(String email, String password, String intendedRole) async {
    try {
      // Perform email/password authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check if the user's role matches the intended role
      if (userDoc.exists && userDoc.data()?['type'] == intendedRole) {
        // Navigate to the appropriate screen
        if (intendedRole == 'tenant') {
          // Navigate to admin screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return TenantDashboardPage(tuid: '${userCredential.user?.uid}');
          }));
        } else {
          // Navigate to public screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return LandlordDashboardPage(lluid: "${userCredential.user?.uid}");
          }));
        }
      } else {
        // Show an error or prevent login
        // Display a message indicating the incorrect role
        UiHelper.CustomAlertBox(context, 'Incorrect role for login');
        print('Incorrect role for login');
        // You can display a snackbar or dialog here
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.toString() == 'user-not-found') {
        UiHelper.CustomAlertBox(context, 'No user found for that email.');
      } else if (e.code.toString() == 'invalid-credential') {
        UiHelper.CustomAlertBox(context, 'Wrong Email or Password provided.');
      } else {
        UiHelper.CustomAlertBox(
            context, "Somthing went wrong. Please Restart App Again.");
      }
    }
  }
 // end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor.primarycolor,
        title: Text("Tenant Login",
            style: TextStyle(
                color: Ccolor.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UiHelper.customLoginSignupTextField(
                  _emailController,
                  "Email",
                  false,
                  Icons.email,
                  TextInputType.emailAddress, validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                if (value == null || value.isEmpty) {
                  return UiHelper.CustomAlertBox(
                      (context), "Email is Required");
                } else if (!regExp.hasMatch(value)) {
                  return UiHelper.CustomAlertBox((context), "Invalid Email");
                } else {
                  return null;
                }
              }),
              UiHelper.customLoginSignupTextField(
                  _passwordController,
                  "Password",
                  true,
                  Icons.password,
                  TextInputType.visiblePassword, validator: (value) {
                if (value == null || value.isEmpty) {
                  return UiHelper.CustomAlertBox(
                      (context), "Password can't be empty");
                } else if (value.length < 6) {
                  return UiHelper.CustomAlertBox(
                      (context), "Password must be longer than 6 characters");
                }
                return null;
              }),
              const SizedBox(height: 20),
              UiHelper.CustomButton(
                () {
                  if (_formKey.currentState?.validate() == true) {
                    // _signIn();
                    _loginUser(_emailController.text, _passwordController.text, 'tenant');
                  } else {
                    UiHelper.CustomAlertBox((context), "Something went wrong ?");
                  }
                },
                "Login",
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
                          builder: (context) => TenantRegistrationPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: Ccolor.primarycolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Ccolor.primarycolor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
