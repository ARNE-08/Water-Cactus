import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/widget/button.dart';
import 'package:watercactus_frontend/widget/wave.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double waveHeight = screenHeight / 2; // Set wave height to half the screen height

    return MaterialApp(
      home: Scaffold(
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'WATER\n',
                              style: GoogleFonts.balooThambi2(
                                textStyle: TextStyle(
                                  fontSize: 75,
                                  fontWeight: FontWeight.w800,
                                  height: 0.9, // Adjust this value to bring the lines closer
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: 'CACTUS',
                              style: GoogleFonts.balooThambi2(
                                textStyle: TextStyle(
                                  fontSize: 75,
                                  fontWeight: FontWeight.w800,
                                  height: 0.9, // Adjust this value to bring the lines closer
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Image.asset('assets/cactus.png', width: 300),
                    ],
                  ), // Example cactus image
                  SizedBox(height: 40),
                  MyElevatedButton(
                    onPressed: () {
                      // Your onPressed function here
                    },
                    text: 'Get started!',
                    width: 310, // Increased width for the button
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Already a user? Login',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
