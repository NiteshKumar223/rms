import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rms/CommonPages/available_rooms_page.dart';
import 'package:rms/LandlordPages/ll_collect_Page.dart';
import 'package:rms/TenantPages/t_comp_box_page.dart';
import 'package:rms/TenantPages/t_profile_page.dart';
import 'package:rms/TenantPages/t_rent_paid_page.dart';
import 'package:rms/TenantPages/t_rent_pay_online_page.dart';
import 'package:rms/customui/uihelper.dart';

import '../CommonPages/about_us_page.dart';
import '../LandlordPages/ll_comp_box_page.dart';
import '../CommonPages/privacy_policy_page.dart';
import '../customui/custom_colors.dart';
import '../main.dart';

class TenantDashboardPage extends StatefulWidget {
  final String tuid;
  const TenantDashboardPage({super.key, required this.tuid});

  @override
  State<TenantDashboardPage> createState() => _TenantDashboardPageState();
}

class _TenantDashboardPageState extends State<TenantDashboardPage> {
  // Store the logged-in user
  late User? loggedInUser;
  String tName = "";
  String ll_uid = "";

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user
    loggedInUser = FirebaseAuth.instance.currentUser;
    // Fetch user data from Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then(
          (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Access the data from the document
          tName = documentSnapshot.get('tName');
          ll_uid = documentSnapshot.get('llUid');
          setState(() {});
        } else {
          UiHelper.showsnackbar(context, 'User document not found in Database.');
        }
      },
    ).catchError((error) {
      UiHelper.showsnackbar(context, 'User document not found in Database : $error');
    });
  }

  logout()async{
    FirebaseAuth.instance.signOut().then((value){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=>LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.customAppbar('Tenant Dashboard'),
      drawer: Drawer(
        width: 230,
        // surfaceTintColor: Colors.red,
        child: Column(
          // padding: EdgeInsets.zero,
          children: [
            Container(
              height: 140,
              width: 230,
              decoration: BoxDecoration(
                color: Ccolor.secondarycolor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Ccolor.primarycolor,
                    child: CircleAvatar(
                        radius: 35,
                        child: Icon(Icons.person,
                            size: 50, color: Ccolor.primarycolor)),
                  ),
                  const SizedBox(height: 15),
                  Text(tName,style: TextStyle(color: Ccolor.white, fontSize: 16)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Home',style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text('My Profile',style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TenantProfilePage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
              ),
              title: const Text('About Us',style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AboutUsPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip_sharp,
              ),
              title: const Text('Privacy Policy',style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>PrivacyPolicyPage())
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Ccolor.red,
              ),
              title: Text('Log Out', style: TextStyle(color: Ccolor.red,fontSize: 14)),
              onTap: () {
                logout();
              },
            ),
            const Spacer(),
            const Text("Version : 1.0.0",style: TextStyle(fontSize: 10)),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        height: 65.0,
        elevation: 50.0,
        backgroundColor: Ccolor.thirdcolor,
        indicatorColor: Ccolor.primarycolor,
        selectedIndex: currentPageIndex,
        destinations:  <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home,color: Ccolor.white),
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.money,color: Ccolor.white),
            icon: const Icon(Icons.money),
            label: 'Pay',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.view_list_sharp,color: Ccolor.white),
            icon: const Icon(Icons.view_list_sharp),
            label: 'Paid',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.question_answer_rounded,color: Ccolor.white),
            icon: const Icon(Icons.question_answer_rounded),
            label: 'Complaints',
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Ccolor.red,
          content: Text('Tap back again to leave'),
        ),
        child: <Widget>[
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: AvailableRoomsPage(),
          ),
          TenantRentPayOnlinePage(lluid: ll_uid),
          TenantRentPaidPage(lluid: ll_uid,tname: tName),
          TenantComplaintBoxPage(lluid: ll_uid),
        ][currentPageIndex],
      ),
    );
  }
}
