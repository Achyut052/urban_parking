import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingModel {
  final String title;
  final String amenities;
  final String capacity;
  final String security;
  final int price;
  final LatLng location;

  ParkingModel({
    required this.title,
    required this.amenities,
    required this.capacity,
    required this.security,
    required this.price,
    required this.location,
  });
}

List<ParkingModel> parkingLocations = [
  ParkingModel(
    title: 'Riverfront House Parking',
    amenities: 'Covered parking, CCTV surveillance',
    capacity: '150 cars',
    security: '24/7',
    price: 300,
    location: const LatLng(23.030513, 72.558251),
  ),
  ParkingModel(
    title: 'Kankaria Lake Parking',
    amenities: 'Open parking, Security guard',
    capacity: '200 cars',
    security: '24/7',
    price: 200,
    location: const LatLng(22.992228, 72.596207),
  ),
  ParkingModel(
    title: 'Law Garden Parking',
    amenities: 'Covered parking, CCTV surveillance',
    capacity: '100 cars',
    security: '24/7',
    price: 400,
    location: const LatLng(23.022505, 72.553792),
  ),
  ParkingModel(
    title: 'Alpha One Mall Parking',
    amenities: 'Covered parking, CCTV surveillance, Valet parking',
    capacity: '200 cars',
    security: '24/7',
    price: 500,
    location: const LatLng(23.0436, 72.5260),
  ),
  ParkingModel(
    title: 'CG Square Mall Parking',
    amenities: 'Covered parking, CCTV surveillance',
    capacity: '100 cars',
    security: '24/7',
    price: 350,
    location: const LatLng(23.0295, 72.5657),
  ),
  ParkingModel(
    title: 'Gandhi Ashram Parking',
    amenities: 'Open parking, Security guard',
    capacity: '50 cars',
    security: 'Daytime only',
    price: 150,
    location: const LatLng(23.0600, 72.5800),
  ),
];
