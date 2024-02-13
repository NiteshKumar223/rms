// import 'package:flutter/material.dart';
// import 'package:rms/customui/custom_colors.dart';
//
// import '../customui/uihelper.dart';
//
// class LandlordCollectionViewPage extends StatefulWidget {
//   const LandlordCollectionViewPage({super.key});
//
//   @override
//   State<LandlordCollectionViewPage> createState() => _LandlordCollectionViewPageState();
// }
//
// class _LandlordCollectionViewPageState extends State<LandlordCollectionViewPage> {
//   DateTime now = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Ccolor.thirdcolor,
//       child: Column(
//         children: [
//           // Container(
//           //   height: 40,
//           //   width: MediaQuery.of(context).size.width,
//           //   color: Ccolor.secondarycolor,
//           //   child: Center(
//           //       child: Text(
//           //     now.year.toString(),
//           //     style: TextStyle(fontSize: 26, color: Ccolor.white),
//           //   )),
//           // ),
//           Expanded(
//             child: ListView.builder(
//                 itemCount: 15,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 20),
//                       height: 260,
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           color: Ccolor.white,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Deposit Date :",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Ccolor.primarycolor)),
//                               Text("December 5, 2023",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Ccolor.primarycolor)),
//                             ],
//                           ),
//                           UiHelper.customRowData("Room No. :", "04"),
//                           UiHelper.customRowData(
//                               "Depositor Name :", "Nitesh Kumar"),
//                           UiHelper.customRowData(
//                               "Previous Electricity Mtr Reading :", "2225"),
//                           UiHelper.customRowData(
//                               "Room Rent :", "\u{20B9} 2000"),
//                           UiHelper.customRowData(
//                               "Electricity Bill :", "\u{20B9} 54"),
//                           UiHelper.customRowData(
//                               "Bathroom/Toilet Rent :", "\u{20B9} 50"),
//                           UiHelper.customRowData("Water Rent :", "\u{20B9} 35"),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Divider(height: 3, color: Ccolor.black),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("TOTAL RENT :",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Ccolor.primarycolor)),
//                               Text("\u{20B9} 2139",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Ccolor.primarycolor)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
