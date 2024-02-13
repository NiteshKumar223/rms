import 'package:flutter/material.dart';

import '../customui/custom_colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Ccolor.primarycolor,
          title: Text(
            "About Us",
            style: TextStyle(
                fontSize: 21,
                color: Ccolor.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Ccolor.white, size: 30.0),
        ),

      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Our App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Made in India Application:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Our application is proudly made in India, supporting local development and innovation.',
            ),
            SizedBox(height: 16),
            Text(
              'Easiest Way to Maintain Tenant Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We provide the easiest and most efficient way for landlords to manage tenant information, ensuring a hassle-free experience in the rental process.',
            ),
            SizedBox(height: 16),
            Text(
              'Rent Collection Simplified:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Our app allows landlords to easily track rent payments, providing a seamless solution for rent collection. Landlords can monitor whether rent is paid or not through their secure login.',
            ),
            SizedBox(height: 16),
            Text(
              'Free of Cost Use:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We believe in providing value to our users. Enjoy the benefits of our app free of charge!',
            ),
            SizedBox(height: 16),
            Text(
              'Great Quality Assurance:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Our application undergoes rigorous quality assurance processes to ensure a reliable and secure experience for our users. Your satisfaction is our top priority.',
            ),

          ],
        ),
      ),
    );
  }
}
