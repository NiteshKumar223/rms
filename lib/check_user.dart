import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rms/main.dart';
import 'LandlordPages/ll_dashboard_page.dart';
import 'TenantPages/t_dashboard_page.dart';


class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

   // Store the logged-in user
  late User? loggedInUser;
  String type = "";

  @override
  void initState() {
    super.initState();

    // Get the currently logged-in user
     loggedInUser = FirebaseAuth.instance.currentUser ?? null;

    // Fetch user data from Firestore
    FirebaseFirestore.instance.collection('users').doc(loggedInUser?.uid).get().then(
          (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Access the data from the document
          type = documentSnapshot.get('type');
          setState(() {});
        } else {
          print('User document not found in Firestore.');
        }
      },
    ).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return checkUser();
  }

  checkUser(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      if (type == "landlord"){
        return LandlordDashboardPage(lluid: '${loggedInUser?.uid}');
      } else if (type == "tenant"){
        return TenantDashboardPage(tuid: '${loggedInUser?.uid}');
      }else{
        return LoginPage();
      }
    }
    else{
      return LoginPage();
    }
  }

}
