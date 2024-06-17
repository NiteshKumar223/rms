import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../customui/custom_colors.dart';
import '../customui/uihelper.dart';

// Define the upload room data model
class RoomListing {
  List<String> imageUrls;
  String roomRent;
  String noOfRoomsAvailable;
  String buildingName;
  List<String> furniture;
  String availableFor;
  String parking;
  String description;
  String nearbyAddress;
  String fullAddress;
  String ownerMobile;
  String llUid;
  DateTime listingDate;

  RoomListing({
    required this.imageUrls,
    required this.roomRent,
    required this.noOfRoomsAvailable,
    required this.buildingName,
    required this.furniture,
    required this.availableFor,
    required this.parking,
    required this.description,
    required this.nearbyAddress,
    required this.fullAddress,
    required this.ownerMobile,
    required this.llUid,
    required this.listingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'aImageUrls': imageUrls,
      'bRoomRent': roomRent,
      'bRoomAvl': noOfRoomsAvailable,
      'cBuilding': buildingName,
      'dFurniture': furniture,
      'eAvailability': availableFor,
      'fParking': parking,
      'gDescription': description,
      'hNearbyAddress': nearbyAddress,
      'iFullAddress': fullAddress,
      'jOwnerMobile': ownerMobile,
      'llUid': llUid,
      'listingDate': listingDate,
    };
  }

  factory RoomListing.fromMap(Map<String, dynamic> map) {
    return RoomListing(
      imageUrls: List<String>.from(map['aImageUrls']),
      roomRent: map['bRoomRent'],
      noOfRoomsAvailable: map['bRoomAvl'],
      buildingName: map['cBuilding'],
      furniture: List<String>.from(map['dFurniture']),
      availableFor: map['eAvailability'],
      parking: map['fParking'],
      description: map['gDescription'],
      nearbyAddress: map['hNearbyAddress'],
      fullAddress: map['iFullAddress'],
      ownerMobile: map['jOwnerMobile'],
      llUid: map['llUid'],
      listingDate: map['listingDate'].toDate(),
    );
  }
}

// Define the RoomData model
class RoomData {
  final List<String> images;
  final String roomRent;
  final String buildingName;
  final String roomCount;
  final String furnishing;
  final String availabilityFor;
  final String parkingAvailable;
  final String descriptionAboutRoom;
  final String nearbyAddress;
  final String fullAddress;
  final String ownerMobile;

  RoomData({
    required this.images,
    required this.roomRent,
    required this.roomCount,
    required this.buildingName,
    required this.furnishing,
    required this.availabilityFor,
    required this.parkingAvailable,
    required this.descriptionAboutRoom,
    required this.nearbyAddress,
    required this.fullAddress,
    required this.ownerMobile,
  });
}

class AvailableRoomsPage extends StatelessWidget {
  const AvailableRoomsPage({super.key});

  Future<List<RoomData>> fetchRoomAvailableData() async {
    List<RoomData> dataList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('rooms_available')
        .orderBy('listingDate', descending: true)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      List<String> images = List.from(doc['aImageUrls']);
      String roomRent = doc['bRoomRent'];
      String roomCount = doc['bRoomAvl'];
      String building = doc['cBuilding'];
      String furniture = doc['dFurniture'];
      String available = doc['eAvailability'];
      String parking = doc['fParking'];
      String description = doc['gDescription'];
      String nearbyAddress = doc['hNearbyAddress'];
      String fullAddress = doc['iFullAddress'];
      String ownerMobile = doc['jOwnerMobile'];

      RoomData userData = RoomData(
        images: images,
        roomRent: roomRent,
        roomCount: roomCount,
        buildingName: building,
        furnishing: furniture,
        availabilityFor: available,
        parkingAvailable: parking,
        descriptionAboutRoom: description,
        nearbyAddress: nearbyAddress,
        fullAddress: fullAddress,
        ownerMobile: ownerMobile,
      );
      dataList.add(userData);
    }
    return dataList;
  }

  openDialPad(String phoneNumber, context) async {
    Uri urlPh = Uri(scheme: "tele", path: phoneNumber);
    if (await canLaunchUrl(urlPh)) {
      await launchUrl(urlPh);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to dial $phoneNumber")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RoomData>>(
      future: fetchRoomAvailableData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<RoomData> dataList = snapshot.data!;

          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              RoomData roomData = dataList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display images in a CarouselSlider
                    const SizedBox(height: 10),
                    Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        // color: Ccolor.grey,
                        border: Border.all(),
                      ),
                      child: CarouselSlider(
                        items: roomData.images.map((imageUrls) {
                          return CachedNetworkImage(
                            imageUrl: imageUrls,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 350.0,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                    // Display other data
                    const SizedBox(height: 28),
                    UiHelper.customRowData(
                        "Rent :", "\u{20B9} ${dataList[index].roomRent}"),
                    const SizedBox(height: 5),
                    UiHelper.customRowData(
                        "Building/Flat :", roomData.buildingName),
                    const SizedBox(height: 5),
                    UiHelper.customRowData(
                        "Rooms Available :", roomData.roomCount),
                    const SizedBox(height: 5),
                    UiHelper.customRowData("Furnishing :", roomData.furnishing),
                    const SizedBox(height: 5),
                    UiHelper.customRowData(
                        "Available For :", roomData.availabilityFor),
                    const SizedBox(height: 5),
                    // UiHelper.customRowData(
                    //     "Electricity Charge :", "As per use"),
                    // const SizedBox(height: 5),
                    // UiHelper.customRowData(
                    //     "Water Charge :", "as per summersible meter"),
                    // const SizedBox(height: 5),
                    UiHelper.customRowData(
                        "Parking Available :", roomData.parkingAvailable),
                    const SizedBox(height: 5),
                    Divider(thickness: 1, color: Ccolor.primarycolor),
                    Text(
                      "Description About Room :",
                      style:
                          TextStyle(fontSize: 15, color: Ccolor.primarycolor),
                    ),
                    Text(
                      roomData.descriptionAboutRoom,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Nearby :",
                      style:
                          TextStyle(fontSize: 15, color: Ccolor.primarycolor),
                    ),
                    Text(
                      roomData.nearbyAddress,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Full Address :",
                      style:
                          TextStyle(fontSize: 15, color: Ccolor.primarycolor),
                    ),
                    Text(
                      roomData.fullAddress,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () =>
                          openDialPad(roomData.ownerMobile, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call, color: Colors.white),
                          Text(" Tap to call",
                              style:
                                  TextStyle(fontSize: 14, color: Ccolor.white))
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Divider(thickness: 5, color: Ccolor.primarycolor),
                    const SizedBox(height: 25),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
