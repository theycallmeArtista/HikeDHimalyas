import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie package for animations

class MoreActivityScreen extends StatelessWidget {
  const MoreActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Activities'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0), // Make the animation card rounded
              child: Container(
                width: double.infinity,
                height: 300.0, // Adjust the height as per your preference
                color: Colors.white,
                child: Lottie.asset(
                  'assets/para_anim.json', // Ensure this is the correct path to your Lottie file
                  fit: BoxFit.cover, // Make the animation cover the card area
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
