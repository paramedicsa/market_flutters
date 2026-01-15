import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistPaymentsScreen extends StatefulWidget {
  const ArtistPaymentsScreen({super.key});

  @override
  State<ArtistPaymentsScreen> createState() => _ArtistPaymentsScreenState();
}

class _ArtistPaymentsScreenState extends State<ArtistPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Payments'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Payment Flow Setup',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement PayFast connection logic
              },
              child: const Text('Connect to PayFast'),
            ),
          ],
        ),
      ),
    );
  }
}
