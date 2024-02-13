// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rms/pages/landlord_sign_up_page.dart';
// import '../customui/custom_colors.dart';
// import '../customui/uihelper.dart';
// import 'landlord_forgot_password.dart';
// import 'landlord_home_page.dart';
//
// class LandlordLoginPage extends StatefulWidget {
//   const LandlordLoginPage({super.key});
//
//   @override
//   State<LandlordLoginPage> createState() => _LandlordLoginPageState();
// }
//
// class _LandlordLoginPageState extends State<LandlordLoginPage> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   login(String email, String password) async {
//     if (email == "" && password == "") {
//       return UiHelper.CustomAlertBox(context, "Enter Required Fields");
//     } else {
//       UserCredential? usercredential;
//       try {
//         usercredential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(email: email, password: password)
//             .then((value) {
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) {
//             return const LandlordHomePage();
//           }));
//         });
//       } on FirebaseAuthException catch (ex) {
//         return UiHelper.CustomAlertBox(context, ex.code.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Ccolor.primarycolor,
//         title: Text("Landlord Login",
//             style: TextStyle(
//                 color: Ccolor.white,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.8)),
//         centerTitle: true,
//       ),
//       body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         UiHelper.customLoginSignupTextField(
//             emailController, "Email", false, Icons.email),
//         UiHelper.customLoginSignupTextField(
//             passwordController, "Password", true, Icons.password),
//         const SizedBox(height: 20),
//         UiHelper.CustomButton(
//           () {
//             login(emailController.text.toString(),
//                 passwordController.text.toString());
//           },
//           "Login",
//         ),
//         const SizedBox(height: 20),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           const Text(
//             "Don't have an account",
//             style: TextStyle(fontSize: 16),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => const LandlordSignUpPage()));
//             },
//             child: Text(
//               "Sign Up",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Ccolor.primarycolor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ]),
//         const SizedBox(height: 20),
//         TextButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ForgotPassword()),
//               );
//             },
//             child: Text(
//               "Forgot Password",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Ccolor.primarycolor,
//               ),
//             )),
//       ]),
//     );
//   }
// }
