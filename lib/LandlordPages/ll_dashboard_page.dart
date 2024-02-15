
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/CommonPages/about_us_page.dart';
import 'package:rms/CommonPages/privacy_policy_page.dart';
import 'package:rms/LandlordPages/ll_pricing_page.dart';
import 'package:rms/LandlordPages/ll_tenants_page.dart';
import 'package:rms/customui/uihelper.dart';
import 'package:rms/main.dart';

import 'll_comp_box_page.dart';
import '../customui/custom_colors.dart';
import 'll_add_room_page.dart';
import 'll_collect_Page.dart';
import 'll_collection_view_page.dart';
import 'll_home_page.dart';
import 'll_profile_page.dart';

class LandlordDashboardPage extends StatefulWidget {
  final String lluid;
  const LandlordDashboardPage({super.key, required this.lluid});

  @override
  State<LandlordDashboardPage> createState() => _LandlordDashboardPageState();
}

class _LandlordDashboardPageState extends State<LandlordDashboardPage> {

  // Store the logged-in user
  late User? loggedInUser;
  String uName = "";

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
          uName = documentSnapshot.get('llName');
          setState(() {});
        } else {
          const SnackBar(
            content: Text('User document not found in Database.'),
          );
        }
      },
    ).catchError((error) {
      SnackBar(
        content: Text('User document not found in Database : $error'),
      );
    });
  }

  logout() async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.customAppbar("Landlord Dashboard"),
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
                  Text(uName,
                      style: TextStyle(color: Ccolor.white, fontSize: 18)),
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
                  return const LandlordProfilePage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
              ),
              title: const Text('My Tenants',style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LandlordTenantsPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.monetization_on,
              ),
              title: const Text('My Pricing',style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LandlordPricingPage();
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
              title: Text('Log Out', style: TextStyle(fontSize: 16,color: Ccolor.red)),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.money,color: Ccolor.white),
            icon: Icon(Icons.money),
            label: 'Collect',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_box,color: Ccolor.white),
            icon: Icon(Icons.add_box),
            label: 'Rooms',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.view_list_sharp,color: Ccolor.white),
            icon: Icon(Icons.view_list_sharp),
            label: 'Paid',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.question_answer_rounded,color: Ccolor.white),
            icon: Icon(Icons.question_answer_rounded),
            label: 'Complaints',
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: <Widget>[
          const LandlordHomePage(),
          const LandlordCollectPage(),
          LandlordAddRoomPage(currindex: currentPageIndex),
          const LandlordCollectionViewPage(),
          const LandlordComplaintBoxPage(),
        ][currentPageIndex],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow, child: const Center(child: Text('Page 1')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController checkController = TextEditingController();
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: checkController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
            ),
          ),
        ));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red, child: const Center(child: Text('Page 3')));
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue, child: const Center(child: Text('Page 4')));
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreenAccent,
        child: const Center(child: Text('Page 5')));
  }
}