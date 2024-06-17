import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/LandlordPages/ll_login_page.dart';
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
        appBar: UiHelper.customAppbar("Password Reset"),
        body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Ccolor.red,
          content: Text('Tap back again to leave the Application'),
        ),
          child: Form(
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
                    return "Email is Required";
                  } else if (!regExp.hasMatch(value)) {
                    return "Invalid Email";
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
          
                }, "Send Reset Link on Email"),
                const SizedBox(height: 50),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("I know Password  ",
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
        ));
  }
}
