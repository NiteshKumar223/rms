import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rms/LandlordPages/ll_login_page.dart';
import 'package:rms/customui/custom_colors.dart';
import 'package:rms/customui/uihelper.dart';
import 'CommonPages/available_rooms_page.dart';
import 'CommonPages/forgot_password.dart';
import 'GuestPages/g_dashboard_page.dart';
import 'LandlordPages/ll_reg_page.dart';
import 'TenantPages/t_login_page.dart';
import 'TenantPages/t_reg_page.dart';
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
        CheckUser(),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset("assets/images/rms_logo.PNG", width: 150, height: 150),
              const SizedBox(height: 60),
              UiHelper.CustomButton(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandlordLoginPage(),
                  ),
                );
              }, "Landlord Login"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("I don't have an Account  ",
                      style: TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LandlordRegistrationPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: Ccolor.primarycolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Ccolor.primarycolor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 50),
              UiHelper.CustomButton(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TenantLoginPage(),
                  ),
                );
              }, "Tenant Login"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("I don't have an Account  ",
                      style: TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TenantRegistrationPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: Ccolor.primarycolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Ccolor.primarycolor,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 50),
              UiHelper.CustomButton(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestDashboardPage(),
                  ),
                );
              }, "As a Guest"),
            ],
          ),
        ),
      ),
    );
  }
}
