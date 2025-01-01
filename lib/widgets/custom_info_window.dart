import 'package:flutter/material.dart';
import 'package:urban_booking/models/parking_model.dart';
import 'package:urban_booking/widgets/button_widget.dart';

class CustomInfoWindow extends StatelessWidget {
  final ParkingModel parking;
  final VoidCallback onBookNow;

  const CustomInfoWindow({
    required this.parking,
    required this.onBookNow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            parking.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Price: ₹${parking.price}/hr',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Capacity: ${parking.capacity}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Security: ${parking.security}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Amenities: ${parking.amenities}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ButtonWidget(
              title: 'Book Now',
              onTap: onBookNow,
            ),
          ),
        ],
      ),
    );
  }
}
