import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class LandlordProfilePage extends StatefulWidget {
  const LandlordProfilePage({super.key});

  @override
  State<LandlordProfilePage> createState() => _LandlordProfilePageState();
}

class _LandlordProfilePageState extends State<LandlordProfilePage> {
  late User loggedInUser;
  late Stream<QuerySnapshot> landlordStream;

  @override
  void initState() {
    super.initState();
    // Fetch the current user information when the widget is initialized
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    loggedInUser = FirebaseAuth.instance.currentUser!;
    landlordStream = FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'landlord')
        .where('llUid', isEqualTo: loggedInUser.uid)
        .snapshots();

    // Force a rebuild after fetching the user information
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UiHelper.customAppbar("Landlord Profile"),
        body: StreamBuilder(
            stream: landlordStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No landlord data found.'),
                );
              }

              // Display the landlord data in the profile
              var landlordData =
                  snapshot.data!.docs[0].data() as Map<String, dynamic>;

              return Column(
                children: [
                  Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
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
                        const SizedBox(height: 10),
                        Text(landlordData['llName'],
                            style:
                                TextStyle(color: Ccolor.white, fontSize: 18)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ProfileData.customRowData(
                            "Name :", landlordData['llName']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "Email :", landlordData['llEmail']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "Mobile No :", landlordData['llMob']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "User Type :", landlordData['type']),
                        const SizedBox(height: 10),
                        Divider(thickness: 5, color: Ccolor.secondarycolor),
                        const SizedBox(height: 10),
                        Container(
                            height: 30,
                            width: 100,
                            color: Ccolor.primarycolor,
                            child: Center(
                                child: Text("User ID",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Ccolor.white)))),
                        const SizedBox(height: 10),
                        SelectableText(landlordData['llUid'],
                            style:
                                TextStyle(fontSize: 15, color: Ccolor.black)),
                        const SizedBox(height: 10),
                        Divider(thickness: 5, color: Ccolor.secondarycolor),
                        const SizedBox(height: 10),
                        const Text(
                            "This User ID will be used in tenant profile login")
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}

class ProfileData {
  static customRowData(String collTitle, String collData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(collTitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Ccolor.primarycolor)),
        Text(collData, style: TextStyle(fontSize: 14, color: Ccolor.black)),
      ],
    );
  }
}
