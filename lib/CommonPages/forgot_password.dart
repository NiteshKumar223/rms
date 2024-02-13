import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/main.dart';
import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  forgotPassword(String email) async {
    if (email == "") {
      return UiHelper.CustomAlertBox(
          context, "Enter your registered Email to reset password");
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Password Reset",
              style: TextStyle(
                  fontSize: 21,
                  color: Ccolor.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8)),
          backgroundColor: Ccolor.primarycolor,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UiHelper.customLoginSignupTextField(emailController, "Email", false,
                  Icons.email, TextInputType.emailAddress, validator: (value) {
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
              }),
              const SizedBox(height: 20),
              UiHelper.CustomButton(() {
                if (_formKey.currentState?.validate() == true) {
                  forgotPassword(emailController.text.toString());
                } else {
                  UiHelper.CustomAlertBox((context), "Something went wrong ?");
                }

              }, "Send Reset Link"),
            ],
          ),
        ));
  }
}
