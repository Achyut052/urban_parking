import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:urban_booking/models/parking_model.dart';
import 'package:urban_booking/widgets/button_widget.dart';

import 'thank_you_screen.dart';

class BookingScreen extends StatefulWidget {
  final ParkingModel parking;

  const BookingScreen({
    super.key,
    required this.parking,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Set<Marker> _markers = {};
  BitmapDescriptor? customIcon;

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        // 'payment_method_types[]': 'card',
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51PjeILEfeauocxuNWY0VDjoF2HojNHWeY0uupmtRY8xztsby5CvEDppSqnE8wPdcW4Z9vua5cr8hKnVAQS8p8cn200r4HcUbk6',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> handlePayment(BuildContext context) async {
    try {
      //STEP 1: Create Payment Intent
      var paymentIntent = await createPaymentIntent(
          (widget.parking.price * 100).toString(), 'inr');

      print('paymentIntent: $paymentIntent');
      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: widget.parking.title,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
                  address: AddressCollectionMode.never),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Handle payment confirmation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThankYouScreen(
            parking: widget.parking,
          ),
        ),
      );
    } on StripeConfigException catch (e, s) {
      print('Error is: $e, $s');
      print('Error is: ${e.message}');
    } on StripeException catch (e, s) {
      print('Error is1: $e, $s');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment failed: ${e.error.localizedMessage}')));
    } catch (e, s) {
      print('ERROR: $e, $s');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

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
          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('selectedParking'),
                position: widget.parking.location,
                consumeTapEvents: false,
                icon: customIcon ?? BitmapDescriptor.defaultMarker,
                draggable: false,
              ),
            );
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Screen'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.parking.location,
                zoom: 16,
              ),
              markers: _markers,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Parking Name: ${widget.parking.title}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: ₹${widget.parking.price}/hr',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Capacity: ${widget.parking.capacity}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Security: ${widget.parking.security}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Amenities: ${widget.parking.amenities}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  title: 'Confirm Booking',
                  onTap: () async {
                    await handlePayment(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
