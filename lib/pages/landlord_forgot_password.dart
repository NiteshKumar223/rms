//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rms/pages/landlord_login_page.dart';
//
// import '../check_user.dart';
// import '../customui/custom_colors.dart';
// import '../customui/uihelper.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   TextEditingController emailController = TextEditingController();
//
//   forgotPassword(String email) async{
//     if(email == ""){
//       return UiHelper.CustomAlertBox(context, "Enter your registered Email to reset password");
//
//     }
//     else{
//       FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckUser()));
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Password Reset",style:TextStyle(color: Ccolor.white,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
//         backgroundColor: Ccolor.primarycolor,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           UiHelper.customLoginSignupTextField(emailController, "Email", false, Icons.email),
//           const SizedBox(height:20),
//           UiHelper.CustomButton(() {
//             forgotPassword(emailController.text.toString());
//           }, "Send Reset Link"),
//
//         ],
//       )
//     );
//   }
// }
