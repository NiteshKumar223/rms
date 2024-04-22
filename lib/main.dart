import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rms/LandlordPages/ll_login_page.dart';
import 'package:rms/customui/uihelper.dart';
import 'GuestPages/g_dashboard_page.dart';
import 'TenantPages/t_login_page.dart';
import 'check_user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RMS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:
        // LoginPage(),
        const CheckUser(),
        // MyHomePage(),
        // LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: Height,
        width: Width,
        // Below is the code for Linear Gradient.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange,Colors.white, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/rms_logo.PNG", width: 100, height: 100),
            const SizedBox(height: 60),
            UiHelper.CustomButton(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LandlordLoginPage(),
                ),
              );
            }, "Landlord Login"),
            const SizedBox(height: 30),
            UiHelper.CustomButton(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TenantLoginPage(),
                ),
              );
            }, "Tenant Login"),
            const SizedBox(height: 30),
            UiHelper.CustomButton(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GuestDashboardPage(),
                ),
              );
            }, "As a Guest"),
          ],
        ),
      ),
    );
  }
}
