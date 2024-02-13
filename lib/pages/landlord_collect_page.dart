//
//
// import 'package:dropdown_textfield/dropdown_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:rms/customui/custom_colors.dart';
// import 'package:rms/customui/uihelper.dart';
//
// enum PaymentMode { Cash, Online }
//
// class LandlordCollectPage extends StatefulWidget {
//   const LandlordCollectPage({super.key});
//
//   @override
//   State<LandlordCollectPage> createState() => _LandlordCollectPageState();
// }
//
// class _LandlordCollectPageState extends State<LandlordCollectPage> {
//   // List<String> monthname = [
//   //   "Select Month",
//   //   "January",
//   //   "February",
//   //   "March",
//   //   "April",
//   //   "May",
//   //   "June",
//   //   "July",
//   //   "August",
//   //   "September",
//   //   "October",
//   //   "November",
//   //   "December"
//   // ];
//   // String? selected_monthname = "Select Month";
//
//   TextEditingController rmNoController = TextEditingController();
//   TextEditingController depNameController = TextEditingController();
//   TextEditingController depDateController = TextEditingController();
//   TextEditingController rmRentController = TextEditingController();
//   TextEditingController elePreMtrController = TextEditingController();
//   TextEditingController eleCurtMtrController = TextEditingController();
//   TextEditingController eleUnitController = TextEditingController();
//   TextEditingController eleBillController = TextEditingController();
//   TextEditingController btRentController = TextEditingController();
//   TextEditingController waterRentController = TextEditingController();
//   TextEditingController totalRentController = TextEditingController();
//
//   double totalEleBill = 0.0;
//   double totalMtrUnits = 0.0;
//   double totalRentAmt = 0.0;
//
//   PaymentMode? _mode = PaymentMode.Cash;
//   showQr() {
//     showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Scan And Pay'),
//         content: Image.asset("assets/images/orgqr.png", height: 300, width: 300),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'OK'),
//             child: const Text('Done', style: TextStyle(fontSize: 20)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   collectionSuccess() {
//     showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text('Collection Status'),
//         content: const Text("Rent collection is Successfully Done",
//             style: TextStyle(fontSize: 16)),
//         actionsAlignment: MainAxisAlignment.center,
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'OK'),
//             child: const Text('OK', style: TextStyle(fontSize: 20)),
//           ),
//         ],
//       ),
//     );
//   }
//   void calculateTotalMtrReading()async {
//     double preMtrRead = double.tryParse(elePreMtrController.text) ?? 0.0;
//     double curtMtrRead = double.tryParse(eleCurtMtrController.text) ?? 0.0;
//     setState(() {
//       totalMtrUnits = curtMtrRead - preMtrRead;
//     });
//   }
//   void calculateTotalEleBill()async {
//     double totalUnits = double.tryParse(eleUnitController.text) ?? 0.0;
//     setState(() {
//       totalEleBill = totalUnits * 9;
//     });
//   }
//    void calculateTotalRent()async{
//     double rm = double.tryParse(rmRentController.text) ?? 0.0;
//     double ele = double.tryParse(eleBillController.text) ?? 0.0;
//     double bt = double.tryParse(btRentController.text) ?? 0.0;
//     double wtr = double.tryParse(waterRentController.text) ?? 0.0;
//     setState(() {
//       totalRentAmt = rm+ele+bt+wtr;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Ccolor.thirdcolor,
//         height: double.infinity,
//         width: double.infinity,
//         child: SingleChildScrollView(
//           child: Column(children: [
//             // Padding(
//             //   padding: const EdgeInsets.all(10.0),
//             //   child: Container(
//             //     height: 60,
//             //     width: MediaQuery.of(context).size.height,
//             //     decoration: BoxDecoration(
//             //         border: Border.all(color: Ccolor.primarycolor, width: 2.0),
//             //         borderRadius: BorderRadius.circular(10.0)),
//             //     // color:Colors.green,
//             //     child: Padding(
//             //       padding: const EdgeInsets.all(10.0),
//             //       child: DropdownButton<String>(
//             //         value: selected_monthname,
//             //         items: monthname
//             //             .map((item) => DropdownMenuItem(
//             //                   value: item,
//             //                   child: Text(item,
//             //                       style: const TextStyle(fontSize: 20)),
//             //                 ))
//             //             .toList(),
//             //         onChanged: (item) =>
//             //             setState(() => selected_monthname = item),
//             //         isExpanded: true,
//             //         iconSize: 35,
//             //         iconEnabledColor: Ccolor.primarycolor,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(height: 10),
//             Padding(
//                 padding: const EdgeInsets.all(10.0),
//               child: TextField(
//                 controller: depDateController,
//                 keyboardType: TextInputType.datetime,
//                 style: const TextStyle(fontSize: 20),
//                 decoration: InputDecoration(
//                   labelText: "Deposit Date",
//                   labelStyle: const TextStyle(fontSize: 20),
//                   hintText: "Choose Deposit Date",
//                   hintStyle: const TextStyle(fontSize: 20),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(width: 2.0, color: Ccolor.primarycolor)),
//                 ),
//                 onTap: ()async{
//                   DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2023),
//                       lastDate: DateTime(2200),
//                       currentDate: DateTime.now(),
//                   );
//                   if(pickedDate != null){
//                     setState(() {
//                       depDateController.text = DateFormat.yMMMMd().format(pickedDate);
//                     });
//                   } else {
//                     setState(() {
//                       depDateController.text = depDateController.text.toString();
//                     });
//                   }
//                 },
//               ),
//             ),
//             UiHelper.CustomTextField(
//                 rmNoController, "Room No.", TextInputType.number),
//             UiHelper.CustomTextField(
//                 depNameController, "Depositor Name", TextInputType.text),
//             UiHelper.CustomTextField(
//                 elePreMtrController, "Previous Meter Reading", TextInputType.number),
//             UiHelper.CustomTextField(
//                 eleCurtMtrController, "Current Meter Reading", TextInputType.number),
//             UiHelper.customCalculator(() {calculateTotalMtrReading();}, "Calculate Total Unit", "$totalMtrUnits"),
//             UiHelper.CustomTextField(
//                 eleUnitController, "Electricity Total Units", TextInputType.number),
//             UiHelper.customCalculator(() {calculateTotalEleBill();}, "Calculate Ele Bill", "\u{20B9} $totalEleBill"),
//             UiHelper.CustomTextField(
//                 eleBillController, "Electricity Bill Rs.", TextInputType.number),
//             UiHelper.CustomTextField(
//                 rmRentController, "Room Rent", TextInputType.number),
//             UiHelper.CustomTextField(
//                 btRentController, "Bathroom/Toilet Rent", TextInputType.number),
//             UiHelper.CustomTextField(
//                 waterRentController, "Water Rent", TextInputType.number),
//             UiHelper.customCalculator(() {
//               calculateTotalRent();
//             }, "Calculate Total Amt", "$totalRentAmt"),
//             UiHelper.CustomTextField(
//                 totalRentController, "Total Rent Amount", TextInputType.number),
//             const SizedBox(height: 10),
//             ListTile(
//               title: const Text('Cash', style: TextStyle(fontSize: 20)),
//               leading: Radio<PaymentMode>(
//                 value: PaymentMode.Cash,
//                 groupValue: _mode,
//                 onChanged: (PaymentMode? value) {
//                   setState(() {
//                     _mode = value;
//                   });
//                 },
//               ),
//             ),
//             ListTile(
//               title: const Text('Online', style: TextStyle(fontSize: 20)),
//               leading: Radio<PaymentMode>(
//                 value: PaymentMode.Online,
//                 groupValue: _mode,
//                 onChanged: (PaymentMode? value) {
//                   setState(() {
//                     _mode = value;
//                     showQr();
//                   });
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             UiHelper.CustomButton(() {
//               collectionSuccess();
//             }, "Submit"),
//             const SizedBox(height: 20),
//           ]),
//         ));
//   }
// }
