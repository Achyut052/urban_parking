import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urban_booking/models/parking_model.dart';
import 'package:urban_booking/screens/booking_screen.dart';
import 'package:urban_booking/widgets/custom_info_window.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.0225, 72.5714); // Ahmedabad

  final Set<Marker> _markers = {};
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(40, 48)),
        'assets/marker.png',
      ).then(
        (value) {
          customIcon = value;
          for (var parking in parkingLocations) {
            setState(() {
              _markers.add(
                getMarker(parking),
              );
            });
          }
        },
      );
    });
  }

  Marker getMarker(ParkingModel parking) {
    return Marker(
      markerId: MarkerId('${parking.title}${parking.price}'),
      position: parking.location,
      icon: customIcon ?? BitmapDescriptor.defaultMarker,
      onTap: () {
        showDialogOnClick(parking);
      },
    );
  }

  showDialogOnClick(ParkingModel parking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.red,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return CustomInfoWindow(
              parking: parking,
              onBookNow: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      parking: parking,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Parking Booking App'),
  //       centerTitle: true,
  //     ),
  //     body: GoogleMap(
  //       onMapCreated: _onMapCreated,
  //       initialCameraPosition: CameraPosition(
  //         target: _center,
  //         zoom: 12.0,
  //       ),
  //       markers: _markers,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Parking'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            markers: _markers,
          ),
          // Positioned(
          //   top: 16,
          //   left: 16,
          //   right: 16,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(12),
          //       boxShadow: const [
          //         BoxShadow(
          //           color: Colors.black26,
          //           offset: Offset(0, 4),
          //           blurRadius: 5,
          //         ),
          //       ],
          //     ),
          //     child: const Row(
          //       children: [
          //         Icon(Icons.search, color: Colors.blue),
          //         SizedBox(width: 8),
          //         Expanded(
          //           child: TextField(
          //             decoration: InputDecoration(
          //               hintText: 'Search for parking',
          //               border: InputBorder.none,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
