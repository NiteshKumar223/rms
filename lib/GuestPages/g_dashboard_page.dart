import 'package:flutter/material.dart';
import 'package:rms/CommonPages/available_rooms_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

class GuestDashboardPage extends StatelessWidget {
  const GuestDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.customAppbar("Guest Dashboard"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          // height: 400,
            // width: 250,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Ccolor.white,
            child: AvailableRoomsPage(),
        ),
      ),
    );
  }
}
