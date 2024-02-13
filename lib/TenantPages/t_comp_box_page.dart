import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rms/customui/uihelper.dart';

import '../customui/custom_colors.dart';

class TenantComplaintBoxPage extends StatefulWidget {
  final String lluid;
  const TenantComplaintBoxPage({super.key, required this.lluid});

  @override
  State<TenantComplaintBoxPage> createState() =>
      _TenantComplaintBoxPageState();
}

class _TenantComplaintBoxPageState extends State<TenantComplaintBoxPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController comTitleController = TextEditingController();
  final TextEditingController comMsgController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String t_uid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    User? user = auth.currentUser;
    if (user != null) {
      t_uid = user.uid;
    }
  }

  // send response to our tenant's complaints
  Future<void> sendComplaint(
      String senderUid, String comTitle, String comMessage) async {
    CollectionReference messages =
    FirebaseFirestore.instance.collection('complaints');
    await messages.add({
      'tUid': senderUid,
      'llUid': widget.lluid,
      'comTitle': comTitle,
      'comMessage': comMessage,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      UiHelper.CustomAlertBox(context, "Complaint is send to your landlord");
    });
    comTitleController.clear();
    comMsgController.clear();
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
  //  fetch response for viewing
  final CollectionReference<Map<String, dynamic>> resCollection =
  FirebaseFirestore.instance.collection('responses');

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getResponse() {
    return resCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    Widget complaints() {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            UiHelper.CustomTextField(
              comTitleController,
              "Problem",
              TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return UiHelper.CustomAlertBox(
                      (context), "Problem is Required");
                }
                return null;
              },
            ),
            UiHelper.CustomTextField(
              comMsgController,
              "Flat,Room No,Description",
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
                sendComplaint(
                  t_uid,
                  comTitleController.text.toString(),
                  comMsgController.text.toString(),
                );
              } else {
                UiHelper.CustomAlertBox((context), "Something went wrong ?");
              }

            }, 'Raise Complaint'),
            const SizedBox(height: 5),
            Divider(thickness: 2.0, color: Ccolor.primarycolor),
            Expanded(
              child: StreamBuilder<
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
              ),
            ),
          ],
        ),
      );
    }
    //

    // complaints
    Widget response() {
      return StreamBuilder<
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
      );
    }

    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: const <Widget>[
          Tab(
            text: "Complaints",
          ),
          Tab(
            text: "Response",
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          complaints(),
          response(),
        ],
      ),
    );
  }
// response
}
