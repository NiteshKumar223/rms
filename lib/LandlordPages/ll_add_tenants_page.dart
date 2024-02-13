import 'package:flutter/material.dart';

import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class LandlordAddTenantsPage extends StatefulWidget {
  const LandlordAddTenantsPage({super.key});

  @override
  State<LandlordAddTenantsPage> createState() => _LandlordAddTenantsPageState();
}

class _LandlordAddTenantsPageState extends State<LandlordAddTenantsPage> {

  TextEditingController tRoomNoController = TextEditingController();
  TextEditingController tNameController = TextEditingController();
  TextEditingController tMobNoController = TextEditingController();
  TextEditingController tEmailController = TextEditingController();
  TextEditingController tAdharController = TextEditingController();
  TextEditingController tAddressController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor.primarycolor,
        title: Text(
          "My Tenants",
          style: TextStyle(
              color: Ccolor.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Ccolor.white, size: 30.0),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Ccolor.white,
        child: Column(
          children: [
            UiHelper.CustomTextField(tRoomNoController, "Room No", TextInputType.number),
            UiHelper.CustomTextField(tNameController, "Name", TextInputType.text),
            UiHelper.CustomTextField(tMobNoController, "Mobile No", TextInputType.phone),
            UiHelper.CustomTextField(tEmailController, "Email Id", TextInputType.emailAddress),
            UiHelper.CustomTextField(tAdharController, "Aadhar No", TextInputType.number),
            UiHelper.CustomTextField(tAddressController, "Address", TextInputType.text),
          ],
        ),
      ),
    );
  }
}
