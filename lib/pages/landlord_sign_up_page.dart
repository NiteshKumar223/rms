// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rms/check_user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../customui/custom_colors.dart';
// import '../customui/uihelper.dart';
// import 'landlord_home_page.dart';
//
// class LandlordSignUpPage extends StatefulWidget {
//   const LandlordSignUpPage({super.key});
//
//   @override
//   State<LandlordSignUpPage> createState() => _LandlordSignUpPageState();
// }
//
// class _LandlordSignUpPageState extends State<LandlordSignUpPage> {
//
//   TextEditingController landlordNameController = TextEditingController();
//   TextEditingController landlordAdharController = TextEditingController();
//   TextEditingController landlordMbController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//
//   @override
//   void dispose() {
//     landlordNameController.dispose();
//     landlordAdharController.dispose();
//     landlordMbController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   signUp(String email, String password) async{
//     if( email == "" && password == ""){
//       UiHelper.CustomAlertBox(context, "Enter Required Fields");
//     } else {
//       UserCredential? usercredential;
//       try {
//         usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//             email: email, password: password).then((value){
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckUser()));
//         });
//       }
//       on FirebaseAuthException catch (ex){
//         return UiHelper.CustomAlertBox(context, ex.code.toString());
//       }
//     }
//     addLandlordDetails(
//         landlordNameController.text.toString(),
//         int.parse(landlordAdharController.text),
//         int.parse(landlordMbController.text),
//         emailController.text.toString(),
//     );
//   }
//
//   Future addLandlordDetails(
//       String llName, int llAadharNo, int llMobileNo, String llEmail
//       ) async {
//     await FirebaseFirestore.instance.collection('landlordDetails').add({
//       'LlName': llName,
//       'LlAadhar No': llAadharNo,
//       'LlMobile No': llMobileNo,
//       'LlEmail': llEmail,
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Ccolor.primarycolor,
//         title: Text(
//             "Landlord SignUp",
//             style:TextStyle(color: Ccolor.white,fontWeight: FontWeight.bold,letterSpacing: 0.8),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height:120),
//               UiHelper.CustomTextField(
//                   landlordNameController, "Name", TextInputType.text),
//               UiHelper.CustomTextField(
//                   landlordAdharController, "Aadhar No.", TextInputType.number),
//               UiHelper.CustomTextField(
//                   landlordMbController, "Mobile No.", TextInputType.number),
//               UiHelper.customLoginSignupTextField(
//                 emailController, "Email", false, Icons.email),
//               UiHelper.customLoginSignupTextField(
//                 passwordController, "Password", true, Icons.password),
//         const SizedBox(height: 20),
//         UiHelper.CustomButton(
//               () {
//                 signUp(emailController.text.toString(), passwordController.text.toString());
//               },
//           "SignUp",
//         ),
//               const SizedBox(height:50),
//         ]),
//       ),
//     );
//   }
// }
