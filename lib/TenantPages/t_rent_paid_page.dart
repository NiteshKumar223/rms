import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class TenantRentPaidPage extends StatefulWidget {
  final String lluid;
  final String tname;
  const TenantRentPaidPage({super.key, required this.lluid, required this.tname});

  @override
  State<TenantRentPaidPage> createState() => _TenantRentPaidPageState();
}

class _TenantRentPaidPageState extends State<TenantRentPaidPage> {
  // DateTime now = DateTime.now();

  late User loggedInUser;
  late Stream<QuerySnapshot> paidRentStream;

  @override
  void initState() {
    super.initState();
    loggedInUser = FirebaseAuth.instance.currentUser!;

    // Set up a stream to listen for changes in the "users" collection
    // where the type is 'tenant' and landlordUid is equal to the landlord's UID
    paidRentStream = FirebaseFirestore.instance
        .collection('paid_rent')
        .where('llUid', isEqualTo: widget.lluid)
        .where('tenantName', isEqualTo: widget.tname)
        .orderBy('dDate', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: paidRentStream,
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
              child: Text('No rent paid data found.'),
            );
          }
          // Display the tenant data in a ListView
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var paidRentData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      height: 275,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Ccolor.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Deposit Date :",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Ccolor.primarycolor)),
                              Text(paidRentData['dDate'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Ccolor.red)),
                            ],
                          ),
                          UiHelper.customRowData(
                              "Depositor Name :", paidRentData['tenantName']),
                          UiHelper.customRowData(
                              "Previous Electricity Mtr Reading :",
                              paidRentData['elePreMtr']),
                          UiHelper.customRowData(
                              "Current Electricity Mtr Reading :",
                              paidRentData['eleCurtMtr']),
                          UiHelper.customRowData(
                              "Total Electricity Unit :",
                              "${paidRentData['eleUnit']}"),
                          UiHelper.customRowData("Room Rent :",
                              "\u{20B9} ${paidRentData['rmRent']}"),
                          UiHelper.customRowData("Electricity Bill :",
                              "\u{20B9} ${paidRentData['eleBill']}"),
                          UiHelper.customRowData("Bathroom/Toilet Cleaning :",
                              "\u{20B9} ${paidRentData['btRent']}"),
                          UiHelper.customRowData("Water Charge :",
                              "\u{20B9} ${paidRentData['waterRent']}"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(height: 3, color: Ccolor.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("TOTAL RENT :",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Ccolor.primarycolor)),
                              Text("\u{20B9} ${paidRentData['totalRent']}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Ccolor.primarycolor)),
                            ],
                          ),
                        ],
                      ),
                    ));
              });
        });
  }
}
