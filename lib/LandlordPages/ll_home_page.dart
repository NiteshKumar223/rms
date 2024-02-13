import 'package:flutter/material.dart';

import '../CommonPages/available_rooms_page.dart';

class LandlordHomePage extends StatefulWidget {
  const LandlordHomePage({super.key});

  @override
  State<LandlordHomePage> createState() => _LandlordHomePageState();
}

class _LandlordHomePageState extends State<LandlordHomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: AvailableRoomsPage(),
    );

  }
}
