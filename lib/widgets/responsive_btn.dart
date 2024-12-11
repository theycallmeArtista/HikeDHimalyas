import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HikedHimalayas/misc/colors.dart';

class Responsive_btn extends StatelessWidget {
  final bool isResponsive;
  final double width;
  final String text; // Added field for button text

  Responsive_btn({
    Key? key,
    required this.width,
    this.isResponsive = false,
    required this.text, // Required text parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.warning,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center text horizontally
        children: [
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16, // Font size
                fontWeight: FontWeight.bold, // Font weight
                fontFamily: 'Jersey10'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
