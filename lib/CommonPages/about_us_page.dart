import 'package:flutter/material.dart';
import 'package:rms/customui/uihelper.dart';

import '../customui/custom_colors.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UiHelper.customAppbar("About Us"),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Our App!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Made in India Application:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Our application is proudly made in India, supporting local development and innovation.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Easiest Way to Maintain Tenant Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'We provide the easiest and most efficient way for landlords to manage tenant information, ensuring a hassle-free experience in the rental process.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Rent Collection Simplified:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Our app allows landlords to easily track rent payments, providing a seamless solution for rent collection. Landlords can monitor whether rent is paid or not through their secure login.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Free of Cost Use:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'We believe in providing value to our users. Enjoy the benefits of our app free of charge!',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Great Quality Assurance:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Our application undergoes rigorous quality assurance processes to ensure a reliable and secure experience for our users. Your satisfaction is our top priority.',
                style: TextStyle(fontSize: 14),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
