import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/customui/uihelper.dart';

import '../LandlordPages/ll_profile_page.dart';
import '../customui/custom_colors.dart';

class TenantProfilePage extends StatefulWidget {
  TenantProfilePage({super.key});

  @override
  State<TenantProfilePage> createState() => _TenantProfilePageState();
}

class _TenantProfilePageState extends State<TenantProfilePage> {
  late User loggedInUser;
  late Stream<QuerySnapshot> tenantStream;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    loggedInUser = FirebaseAuth.instance.currentUser!;
    tenantStream = FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'tenant')
        .where('tUid', isEqualTo: loggedInUser.uid)
        .snapshots();

    // Force a rebuild after fetching the user information
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UiHelper.customAppbar('My Profile'),
        body: StreamBuilder(
            stream: tenantStream,
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
                  child: Text('No tenant data found. ${snapshot.error}'),
                );
              }

              // Display the landlord data in the profile
              var tenantData =
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
                        Text(tenantData['tName'],
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
                            "Name :", tenantData['tName']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "Room No :", tenantData['tRoomNo']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "Email :", tenantData['tEmail']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "Mobile No :", tenantData['tMobile']),
                        const SizedBox(height: 10),
                        ProfileData.customRowData(
                            "User Type :", tenantData['type']),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Permanent Address :",
                                style: TextStyle(
                                    fontSize: 16, color: Ccolor.primarycolor)),
                            SizedBox(
                                height: 150,
                                width: 160,
                                child: Text(tenantData['tAddress'],
                                    style: TextStyle(
                                        fontSize: 14, color: Ccolor.black))),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );
            }));
  }
}
