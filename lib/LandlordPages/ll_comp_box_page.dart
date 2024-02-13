import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/customui/uihelper.dart';

import '../customui/custom_colors.dart';

class LandlordComplaintBoxPage extends StatefulWidget {
  const LandlordComplaintBoxPage({super.key});

  @override
  State<LandlordComplaintBoxPage> createState() =>
      _LandlordComplaintBoxPageState();
}

class _LandlordComplaintBoxPageState extends State<LandlordComplaintBoxPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController resTitleController = TextEditingController();
  final TextEditingController resMsgController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String ll_uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    User? user = auth.currentUser;
    if (user != null) {
      ll_uid = user.uid;
    }
  }

  // send response to our tenant's complaints
  Future<void> sendResponse(
      String senderUid, String resTitle, String resMessage) async {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('responses');
    await messages.add({
      'llUid': senderUid,
      'resTitle': resTitle,
      'resMessage': resMessage,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      UiHelper.CustomAlertBox(context, "Response is send to your tenants");
    });
    resTitleController.clear();
    resMsgController.clear();
  }

  //  fetch response for viewing
  final CollectionReference<Map<String, dynamic>> resCollection =
      FirebaseFirestore.instance.collection('responses');

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getResponse() {
    return resCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
  //  fetch complaint for viewing
  final CollectionReference<Map<String, dynamic>> compCollection =
  FirebaseFirestore.instance.collection('complaints');

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getComplaints() {
    return compCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    Widget response() {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            UiHelper.CustomTextField(
              resTitleController,
              "Response Against Problem",
              TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return UiHelper.CustomAlertBox(
                      (context), "response Against problem is Required");
                }
                return null;
              },
            ),
            UiHelper.CustomTextField(
              resMsgController,
              "Response Message",
              TextInputType.text,
              isMultiline: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return UiHelper.CustomAlertBox(
                      (context), "Message is Required");
                }
                return null;
              },
            ),
            UiHelper.CustomButton(() {
              if (_formKey.currentState?.validate() == true) {
                sendResponse(
                  ll_uid,
                  resTitleController.text.toString(),
                  resMsgController.text.toString(),
                );
              } else {
                UiHelper.CustomAlertBox((context), "Something went wrong ?");
              }

            }, 'Send Response'),
            const SizedBox(height: 5),
            Divider(thickness: 2.0, color: Ccolor.primarycolor),
            Expanded(
              child: StreamBuilder<
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                stream: getResponse(),
                builder: (context, snapshot) {
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

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No response available.'),
                    );
                  }

                  // Display the notes in a ListView
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> noteData =
                          snapshot.data![index].data();
                      String restitle = noteData['resTitle'];
                      String resdescription = noteData['resMessage'];

                      return Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Problem:",style: TextStyle(color: Ccolor.primarycolor)),
                              Text(restitle),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description:",style: TextStyle(color: Ccolor.primarycolor)),
                              Text(resdescription),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // complaints
    Widget complaints() {
      return StreamBuilder<
          List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: getComplaints(),
        builder: (context, snapshot) {
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No response available.'),
            );
          }

          // Display the notes in a ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> noteData =
              snapshot.data![index].data();
              String comtitle = noteData['comTitle'];
              String comdescription = noteData['comMessage'];

              return Card(
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Problem:",style: TextStyle(color: Ccolor.primarycolor)),
                      Text(comtitle),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Flat,Room No,Description:",style: TextStyle(color: Ccolor.primarycolor)),
                      Text(comdescription),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: TabBar(
        // indicator: BoxDecoration(color: Ccolor.thirdcolor),
        indicatorColor: Ccolor.primarycolor,
        controller: _tabController,
        tabs: const <Widget>[
          Tab(
            text: "Response",
          ),
          Tab(
            text: "Complaints",
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          response(),
          complaints(),
        ],
      ),
    );
  }
  // response
}
