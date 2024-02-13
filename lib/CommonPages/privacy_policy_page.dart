import 'package:flutter/material.dart';

import '../customui/custom_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Ccolor.primarycolor,
        title: Text(
          "Privacy Policy",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: [Date]',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '1. Introduction',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Welcome to [Your App Name] ("we," "us," "our," or "Company"). '
                    'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and any related services (collectively, the "Service").',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '2. Information We Collect',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Add the content for Information We Collect section
              // ...

              SizedBox(height: 16),
              Text(
                '3. How We Use Your Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Add the content for How We Use Your Information section
              // ...

              SizedBox(height: 16),
              Text(
                '4. Disclosure of Your Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Add the content for Disclosure of Your Information section
              // ...

              // Include other sections as needed

              SizedBox(height: 16),
              Text(
                '9. Contact Us',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'If you have any questions or concerns about this Privacy Policy, please contact us at [your contact information].',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
