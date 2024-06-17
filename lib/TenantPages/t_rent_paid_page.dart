import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class TenantRentPaidPage extends StatefulWidget {
  final String lluid;
  final String tname;
  const TenantRentPaidPage(
      {super.key, required this.lluid, required this.tname});

  @override
  State<TenantRentPaidPage> createState() => _TenantRentPaidPageState();
}

class _TenantRentPaidPageState extends State<TenantRentPaidPage> {
  // DateTime now = DateTime.now();

  late User loggedInUser;
  late Stream<QuerySnapshot> paidRentStream;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('paid_rent');

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

  Future<Uint8List> generatePdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    const itemsPerPage = 3; // Adjust this based on your content's size
    int totalPages = (data.length / itemsPerPage).ceil();

    for (int i = 0; i < totalPages; i++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.ListView.builder(
              itemCount: itemsPerPage,
              itemBuilder: (context, index) {
                int dataIndex = i * itemsPerPage + index;
                if (dataIndex >= data.length)
                  return pw.Container(); // Handle overflow
                return pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Deposit Date: ${data[dataIndex]['dDate']}",
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          "Depositor Name: ${data[dataIndex]['tenantName']}"),
                      pw.Text(
                          "Previous Electricity Meter Reading: ${data[dataIndex]['elePreMtr']}"),
                      pw.Text(
                          "Current Electricity Meter Reading: ${data[dataIndex]['eleCurtMtr']}"),
                      pw.Text(
                          "Total Electricity Unit: ${data[dataIndex]['eleUnit']}"),
                      pw.Text(
                          "Room Rent: \u{20B9} ${data[dataIndex]['rmRent']}"),
                      pw.Text(
                          "Electricity Bill: \u{20B9} ${data[dataIndex]['eleBill']}"),
                      pw.Text(
                          "Bathroom/Toilet Cleaning: \u{20B9} ${data[dataIndex]['btRent']}"),
                      pw.Text(
                          "Water Charge: \u{20B9} ${data[dataIndex]['waterRent']}"),
                      pw.Divider(),
                      pw.Text(
                          "TOTAL RENT: \u{20B9} ${data[dataIndex]['totalRent']}",
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Paid List'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              List<Map<String, dynamic>> listData = [];
              final querySnapshot = await collectionReference
                  .where('llUid', isEqualTo: widget.lluid)
                  .where('tenantName', isEqualTo: widget.tname)
                  .orderBy('dDate', descending: true)
                  .get();
              for (var doc in querySnapshot.docs) {
                listData.add(doc.data() as Map<String, dynamic>);
              }

              Uint8List pdfData = await generatePdf(listData);

              await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdfData);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Ccolor.primarycolor),
            ),
            child: Icon(Icons.save, color: Ccolor.white),
          ),
        ],
      ),
      body: StreamBuilder(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        height: 280,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Ccolor.primarycolor)),
                                Text(paidRentData['dDate'],
                                    style: TextStyle(
                                        fontSize: 16,
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
                            UiHelper.customRowData("Total Electricity Unit :",
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Ccolor.primarycolor)),
                                Text("\u{20B9} ${paidRentData['totalRent']}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Ccolor.primarycolor)),
                              ],
                            ),
                          ],
                        ),
                      ));
                });
          }),
    );
  }
}
