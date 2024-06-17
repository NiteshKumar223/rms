
// ignore: file_names
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rms/customui/custom_colors.dart';
import 'package:rms/customui/uihelper.dart';

enum PaymentMode {online}

class TenantRentPayOnlinePage extends StatefulWidget {
  final String lluid;
  const TenantRentPayOnlinePage({super.key, required this.lluid});

  @override
  State<TenantRentPayOnlinePage> createState() => _TenantRentPayOnlinePageState();
}

class _TenantRentPayOnlinePageState extends State<TenantRentPayOnlinePage> {
  TextEditingController elePreMtrController = TextEditingController();
  TextEditingController eleCurtMtrController = TextEditingController();
  Color buttonColor1 = Ccolor.primarycolor;
  Color buttonColor2 = Ccolor.primarycolor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String? get paymentId => null;

  @override
  void dispose() {
    elePreMtrController.dispose();
    eleCurtMtrController.dispose();
    razorpay.clear();
    super.dispose();
  }

  double totalEleBill = 0.0;
  double totalMtrUnits = 0.0;
  double totalRentAmt = 0.0;

  PaymentMode? _mode = PaymentMode.online;

  // it is for select the tenant
  List<String> tenantNames = [];
  String? selectedTenant;
  late User loggedInUser;
  String todayDate = '';

  late CollectionReference<Map<String, dynamic>> usersCollection;

  late Razorpay razorpay;
  var ki = dotenv.env['key_id'];
  var ks = dotenv.env['key_secret'];

  @override
  void initState() {
    super.initState();
    String dateT = DateFormat("MMMM, dd, yyyy").format(DateTime.now());
    usersCollection = FirebaseFirestore.instance.collection('users');
    fetchTenantNames(context);
    setState(() {
      todayDate = dateT;
    });
    imageUrl =
        "https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1703520381~exp=1703520981~hmac=fda9b147134991e9028f877ef241a1d2bed69d739686dbed5fcbbdff08d6d09a";
    elePerUnit = double.tryParse("Laoding..");
    roomRent = double.tryParse("Laoding..");
    btCleaningCharge = double.tryParse("Laoding..");
    waterCharge = double.tryParse("Laoding..");
    llPricingData(context);
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  // payment Gateway
  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         backgroundColor: Colors.white,
    //         actionsAlignment: MainAxisAlignment.center,
    //         title: const Text("Payment Success"),
    //         titleTextStyle: const TextStyle(fontSize: 20, color: Colors.green),
    //         actionsPadding: const EdgeInsets.symmetric(vertical: 0),
    //         content: SizedBox(
    //           height: 65,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text("Ref Id: ${response.paymentId}"),
    //               Text("Order Id: ${response.orderId}"),
    //               Text("Signature Id: ${response.signature}"),
    //             ],
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: const Text(
    //               "OK",
    //               style: TextStyle(fontSize: 20, color: Colors.green),
    //             ),
    //           ),
    //         ],
    //       );
    //     });
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(
      content: Text("Payment Success: ${response.paymentId!}"),
      backgroundColor: Colors.green,
    ));
    rentCollection(context, response.paymentId!);
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
    ));
  }

  void openCheckout(double rs) {
    var options = {
      "key": ki,
      "amount": rs * 100,
      "name": "RMS",
      "description": "Payment for Tenancy Services",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "",
        "email": "",
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      UiHelper.showsnackbar(context, e.toString());
    }
  }

  // Reference to the Firestore collection 'paid_rent'
  CollectionReference<Map<String, dynamic>> paidRentCollection =
      FirebaseFirestore.instance.collection('paid_rent');

  // ... (other methods)
  late String imageUrl;
  late var elePerUnit;
  late var roomRent;
  late var btCleaningCharge;
  late var waterCharge;
  // Add other data fields as needed

  Future<String?> getCurrentUserUid() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      return uid;
    } else {
      UiHelper.showsnackbar(context, 'No user is currently logged in.');
      return null;
    }
  }

  Future<void> llPricingData(context) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> pricingData =
          await FirebaseFirestore.instance
              .collection('pricing_data')
              .doc(widget.lluid)
              .get();
      // return pricingData;
      setState(() {
        imageUrl = pricingData['qrUrl'];
        elePerUnit = double.tryParse(pricingData['eleCostPerUnit']);
        roomRent = double.tryParse(pricingData['costPerRoom']);
        btCleaningCharge = double.tryParse(pricingData['tbCleanPerMonth']);
        waterCharge = double.tryParse(pricingData['waterPerMonth']);

        // Add more fields as needed
      });
    } catch (e) {
      // print('Error loading user data: $e');
      // Handle errors, e.g., display a placeholder image and default user data
      UiHelper.showsnackbar(context, "loading user data: Failed ! Try after sometime");
      setState(() {
        imageUrl =
            "https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1703520381~exp=1703520981~hmac=fda9b147134991e9028f877ef241a1d2bed69d739686dbed5fcbbdff08d6d09a";
        elePerUnit = double.tryParse("Laoding..");
        roomRent = double.tryParse("Laoding..");
        btCleaningCharge = double.tryParse("Laoding..");
        waterCharge = double.tryParse("Laoding..");
        // Set default values for other fields as needed
      });
    }
  }
  

  Future rentCollection(context,String payid) async {
    try {
      // Store data in the 'paid_rent' collection
      await paidRentCollection.add({
        'paymentId': payid,
        'tenantName': selectedTenant,
        'tenantUid': loggedInUser.uid,
        'elePreMtr': elePreMtrController.text,
        'eleCurtMtr': eleCurtMtrController.text,
        'eleUnit': totalMtrUnits,
        'eleBill': totalEleBill,
        'rmRent': roomRent,
        'btRent': btCleaningCharge,
        'waterRent': waterCharge,
        'totalRent': totalRentAmt,
        'payBy': _mode.toString(),
        'llUid': widget.lluid,
        'dDate': todayDate,
        // Add other fields as needed
      }).then((value) => collectionSuccess());

      // Optionally, clear the text fields after storing data
      elePreMtrController.clear();
      eleCurtMtrController.clear();
      setState(() {
        selectedTenant = null;
        _mode = PaymentMode.online;
      });

      // Add any additional logic after storing data if needed
    } catch (e) {
      UiHelper.showsnackbar(
          (context), "Rent Collection Failed : ${e.toString()}");
    }
  }

  void fetchTenantNames(context) async {
    try {
      loggedInUser = FirebaseAuth.instance.currentUser!;
      // Fetch the tenants with type 'tenant' and matching landlord UID
      var snapshot = await usersCollection
          .where('type', isEqualTo: 'tenant')
          .where('llUid', isEqualTo: widget.lluid)
          .where('tUid', isEqualTo: loggedInUser.uid)
          .get();
      // Extract tenant names from documents
      List<String> names =
          snapshot.docs.map((doc) => doc['tName'] as String).toList();

      setState(() {
        tenantNames = names;
      });
    } catch (e) {
      UiHelper.showsnackbar(context, 'Error fetching tenant names: $e');
    }
  }

  collectionSuccess() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Collection Status'),
        content: const Text("Rent collection is Successfully Done",
            style: TextStyle(fontSize: 16)),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }



  void calculateTotalEleBill() async {
    double preMtrRead = double.tryParse(elePreMtrController.text) ?? 0.0;
    double curtMtrRead = double.tryParse(eleCurtMtrController.text) ?? 0.0;
    double oneUnitCost = double.tryParse(elePerUnit.toString()) ?? 0.0;
    setState(() {
      totalMtrUnits = curtMtrRead - preMtrRead;
      totalEleBill = totalMtrUnits * oneUnitCost;
    });
  }

  void calculateTotalRent() async {
    double rm = double.tryParse(roomRent.toString()) ?? 0.0;
    double ele = totalEleBill;
    double bt = double.tryParse(btCleaningCharge.toString()) ?? 0.0;
    double wtr = double.tryParse(waterCharge.toString()) ?? 0.0;
    setState(() {
      totalRentAmt = rm + ele + bt + wtr;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Ccolor.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  UiHelper.CustomDropdown(
                    items: tenantNames,
                    hintText: 'Select Tenant',
                    onChanged: (value) {
                      setState(() {
                        selectedTenant = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tenant selection is Required";
                      }
                      return null;
                    },
                  ),
                  // Text("${selectedTenant}'s previous ele Unit is $preEleUnit"),
                  UiHelper.CustomTextField(
                    elePreMtrController,
                    "Previous Meter Reading",
                    TextInputType.number,
                    validator:(value) {
                      String pattern = r'(^[0-9]*$)';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 
                            "Previous meter reading is Required for calculation of current month electricity bill";
                      } else if (!regExp.hasMatch(value)) {
                        return "Meter reading must be in digits";
                      }
                      return null;
                    },
                  ),
                  UiHelper.CustomTextField(
                    eleCurtMtrController,
                    "Current Meter Reading",
                    TextInputType.number,
                    validator:(value) {
                      String pattern = r'(^[0-9]*$)';
                      RegExp regExp = RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return "Current meter reading is Required for calculation of current month electricity bill";
                      } else if (!regExp.hasMatch(value)) {
                        return "Meter reading must be in digits";
                      }
                      return null;
                    },
                  ),

                  UiHelper.customCalculator(() {
                    calculateTotalEleBill();
                    setState(() {
                      buttonColor1 = Colors.red;
                    });
                  }, "Calculate Electricity Bill", buttonColor1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        UiHelper.customRowData(
                            "Room Rent:", "\u{20B9} $roomRent"),
                        const SizedBox(height: 5),
                        UiHelper.customRowData("Total Electricity Bill:",
                            "\u{20B9} $totalEleBill"),
                        const SizedBox(height: 5),
                        UiHelper.customRowData("Toilet/Bathroom Cleaning:",
                            "\u{20B9} $btCleaningCharge"),
                        const SizedBox(height: 5),
                        UiHelper.customRowData(
                            "Water Charge:", "\u{20B9} $waterCharge"),
                        const SizedBox(height: 5),
                        Divider(thickness: 2, color: Ccolor.primarycolor),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Rent :",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Ccolor.black,
                                    fontWeight: FontWeight.bold)),
                            Text("\u{20B9} $totalRentAmt",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Ccolor.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  UiHelper.customCalculator(() {
                    calculateTotalRent();
                    setState(() {
                      buttonColor2 = Colors.red;
                    });
                  }, "Calculate Total Rent", buttonColor2),

                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Online', style: TextStyle(fontSize: 16)),
                    leading: Radio<PaymentMode>(
                      value: PaymentMode.online,
                      groupValue: _mode,
                      onChanged: (PaymentMode? value) {
                        setState(() {
                          _mode = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  UiHelper.CustomButton(() {
                    
                    if (_formKey.currentState?.validate() == true) {
                      try {
                        openCheckout(totalRentAmt);
                      } catch (e) {
                        UiHelper.showsnackbar(context, e.toString());
                      }
                    } else {
                      UiHelper.showsnackbar(
                          (context), "Something went wrong ?");
                    }
                  }, "Pay"),
                  const SizedBox(height: 80),
                ]),
          ),
        ));
  }
}
