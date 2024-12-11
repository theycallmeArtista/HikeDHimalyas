import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;

  const CardWidget({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550, // Increased card size
      margin: const EdgeInsets.symmetric(horizontal: 15), // Card margin
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(color: Colors.white, width: 4), // White border around card
        image: DecorationImage(
          image: NetworkImage(imageUrl), // Use the same image as the background
          fit: BoxFit.cover, // Make sure the image covers the card
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow for card depth
            blurRadius: 10,
            offset: Offset(0, 5), // Shadow position
          ),
        ],
      ),
      child: Stack(
        children: [
          // Add a transparent overlay to improve text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4), // Dark transparent overlay
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Text and white line would go here (already handled in the Home widget)
        ],
      ),
    );
  }
}
