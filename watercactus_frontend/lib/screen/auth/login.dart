import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/widget/wave.dart';
import 'package:watercactus_frontend/widget/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
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
                  LoginBox(), // Include the LoginBox here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginBox extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> _signin(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        final token = jsonResponse['data']['token'];
        await storage.write(key: 'jwt_token', value: token);
        print("Token stored successfully");
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${jsonResponse['error']}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: Server error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              spreadRadius: 0,
              offset: Offset(0, 10), // Bottom shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Login',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.person), // User icon
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock), // Lock icon
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MyElevatedButton(
                onPressed: () {
                  _signin(context);
                },
                text: 'LOGIN',
                width: 310, // Increased width for the button
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text.rich(
                TextSpan(
                  text: 'Don’t have an account? ',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  children: [
                    TextSpan(
                      text: 'Signup',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(10, 105, 216, 1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
