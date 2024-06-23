import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/widget/wave.dart';
import 'package:watercactus_frontend/widget/button.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EditUnitPage extends StatefulWidget {
  @override
  _EditUnitPageState createState() => _EditUnitPageState();
}

class _EditUnitPageState extends State<EditUnitPage> {
  Future<String?> getToken() async {
    return Provider.of<TokenProvider>(context, listen: false).token;
  }

  Future<void> _sendUnit(BuildContext context, String unit, String token) async {
    final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    
    print("Sending unit with token: $token");
    final response = await http.post(
      Uri.parse('$apiUrl/addUnit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'unit': unit}),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to set unit')),
      );
    }
  }

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
          Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/back.png',
                  width: 48, // Adjust the size as necessary
                  height: 48, // Adjust the size as necessary
                ),
              ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: FutureBuilder<String?>(
                future: getToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No token found');
                  } else {
                    final token = snapshot.data!;
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
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
                            _sendUnit(context, 'oz', token);
                          },
                          text: 'oz (ounces)',
                          width: 275,
                          height: 65, // Increased width for the button
                          backgroundColor: const Color.fromRGBO(88, 210, 255, 1),
                        ),
                        SizedBox(height: 20),
                        MyElevatedButton(
                          onPressed: () {
                            _sendUnit(context, 'ml', token);
                          },
                          text: 'ml (milliliters)',
                          width: 275,
                          height: 65, // Increased width for the button
                          backgroundColor: const Color.fromRGBO(88, 210, 255, 1),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
