import 'dart:ui'; // Required for the ImageFilter.blur
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String imageUrl;

  const BackgroundWidget({
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The background image
        Container(
          height: double.infinity, // Full screen height
          width: double.infinity, // Full screen width
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl), // Use the image URL
              fit: BoxFit.cover, // Cover the entire background
            ),
          ),
        ),
        // The blur effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Apply the blur with desired intensity
            child: Container(
              color: Colors.black.withOpacity(0), // Transparent container to allow blur effect
            ),
          ),
        ),
        // The gradient on top of the blurred background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 1.0], // Smooth gradient for readability
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.9), // Darken the bottom area for better text visibility
              ],
            ),
          ),
        ),
      ],
    );
  }
}
