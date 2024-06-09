import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyElevatedButton extends StatelessWidget {
  final double? width;
  final double height;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final String text;

  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width = 350.0, // Increased default width
    this.height = 60.0, // Increased default height
    this.backgroundColor = const Color.fromRGBO(43, 96, 158, 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(height / 2); // Make the button very round
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor, // Set the background color
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 4), // Changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Set to transparent to use container's color
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        ),
        child: Text(
          text,
          style: GoogleFonts.balooThambi2(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24.0, // Increase font size
          ),
        ),
      ),
    );
  }
}
