// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:rms/pages/landlord_collect_page.dart';
//
// import '../customui/custom_colors.dart';
// import 'landlord_collection_view_page.dart';
// import 'landlord_login_page.dart';
//
//
// class LandlordHomePage extends StatefulWidget {
//   const LandlordHomePage({super.key});
//
//   @override
//   State<LandlordHomePage> createState() => _LandlordHomePageState();
// }
//
// class _LandlordHomePageState extends State<LandlordHomePage> {
//   String user = "Amit";
//
//   int _selectedIndex = 0;
//
//   static const List<Widget> _widgetOptions = <Widget>[
//     LandlordCollectPage(),
//     LandlordCollectionViewPage()
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   logout()async{
//     FirebaseAuth.instance.signOut().then((value){
//       Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context)=>LandlordLoginPage()),
//       );
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome $user",style:TextStyle(color: Ccolor.white,fontWeight: FontWeight.bold,letterSpacing: 0.8)),
//         backgroundColor: Ccolor.primarycolor,
//         actions: [
//           IconButton(onPressed: (){logout();}, icon: Icon(Icons.logout,color: Ccolor.white,size: 35)),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: Ccolor.white,
//         elevation: 12.0,
//         width: 200,
//         child: Container(
//           child: Text("Hello User"),
//         ),
//       ),
//       body: _widgetOptions.elementAt(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Ccolor.primarycolor,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.yellow,
//         selectedFontSize: 15,
//         unselectedIconTheme: const IconThemeData(size: 18),
//         selectedIconTheme: const IconThemeData(size: 24.0,color:Colors.yellow),
//         unselectedItemColor: Colors.white,
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.money),
//             label: 'Collect',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Collection View',
//           ),
//         ],
//
//       ),
//
//
//     );
//   }
// }
