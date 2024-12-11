import 'package:flutter/material.dart';

class AppLargetext extends StatelessWidget {
  final double size;
  final String text;
  final Color color;

  // Constructor with optional parameters
  const AppLargetext({
    Key? key,
    required this.text,
    this.color = Colors.black87,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        letterSpacing: 1.0,
        fontFamily: 'Play',

      ),
    );
  }
}
