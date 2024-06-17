import 'package:flutter/material.dart';

import '../CommonPages/available_rooms_page.dart';

class LandlordHomePage extends StatelessWidget {
  const LandlordHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AvailableRoomsPage(),
    );

  }
}
