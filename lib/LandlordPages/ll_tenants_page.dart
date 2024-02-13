import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/customui/uihelper.dart';

import '../customui/custom_colors.dart';

class LandlordTenantsPage extends StatefulWidget {
  const LandlordTenantsPage({super.key});

  @override
  State<LandlordTenantsPage> createState() => _LandlordTenantsPageState();
}

class _LandlordTenantsPageState extends State<LandlordTenantsPage> {
  late User loggedInUser;
  late Stream<QuerySnapshot> tenantsStream;

  @override
  void initState() {
    super.initState();
    loggedInUser = FirebaseAuth.instance.currentUser!;

    // Set up a stream to listen for changes in the "users" collection
    // where the type is 'tenant' and landlordUid is equal to the landlord's UID
    tenantsStream = FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'tenant')
        .where('llUid', isEqualTo: loggedInUser.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Ccolor.primarycolor,
          title: Text(
            "My Tenants",
            style: TextStyle(
                fontSize: 21,
                color: Ccolor.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Ccolor.white, size: 30.0),
        ),
        body: StreamBuilder(
            stream: tenantsStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Ccolor.primarycolor),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No tenant data found.'),
                );
              }
             // Display the tenant data in a ListView
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var tenantData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      child: Container(
                        padding: const  EdgeInsets.all(8.0),
                        // height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Ccolor.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UiHelper.customRowData("Room No:", tenantData['tRoomNo']),
                            UiHelper.customRowData("Name:", tenantData['tName']),
                            UiHelper.customRowData("Mobile No:", tenantData['tMobile']),
                            UiHelper.customRowData("Email Id:", tenantData['tEmail']),
                            Text("Permanent Address:",style: TextStyle(fontSize: 14,color: Ccolor.primarycolor)),
                            Text(
                              tenantData['tAddress'],
                                style: TextStyle(fontSize: 14,color: Ccolor.black),
                              textAlign: TextAlign.justify,
                            ),
                          ]
                        ),
                      ),
                    );
                  });
            })

        );
  }
}
