import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/widget/wave.dart';
import 'package:watercactus_frontend/widget/button.dart';

class UnitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height + 600;
    final double waveHeight = screenHeight / 2; // Set wave height to half the screen height

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Color.fromRGBO(255, 255, 255, 1), // Background color for the top part
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: WaveClipper(waveHeight: waveHeight), // Use dynamic wave height
              child: Container(
                color: const Color.fromRGBO(172, 230, 255, 1),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'What\'s your\n',
                          style: GoogleFonts.balooThambi2(
                            textStyle: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w800,
                              height: 0.9, // Adjust this value to bring the lines closer
                              color: Color.fromRGBO(43, 96, 158, 1),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: 'unit',
                          style: GoogleFonts.balooThambi2(
                            textStyle: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w800,
                              height: 0.9, // Adjust this value to bring the lines closer
                              color: Color.fromRGBO(43, 96, 158, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  MyElevatedButton(
                    onPressed: () {
                    },
                    text: 'oz (ounces)',
                    width: 275,
                    height: 65, // Increased width for the button
                    backgroundColor: const Color.fromRGBO(88, 210, 255, 1)
                  ),
                  SizedBox(height: 20),
                  MyElevatedButton(
                    onPressed: () {
                    },
                    text: 'ml (milliliters)',
                    width: 275,
                    height: 65, // Increased width for the button
                    backgroundColor: const Color.fromRGBO(88, 210, 255, 1)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
