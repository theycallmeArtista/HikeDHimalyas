import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final TextAlign textAlign;

  // Constructor with parameters
  const AppText({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.size = 8,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(



        fontSize: size,

        color: color,
        fontFamily: 'Rock', // Apply custom font family here
      ),
    );
  }
}
