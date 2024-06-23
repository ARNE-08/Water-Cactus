import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/widget/numpad.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String? _selectedGender;
  String? _selectedActivityRate;
  TextEditingController _weightController = TextEditingController();
  String _customGoal = "0";
  String _unit = "ml";
  String _goal = "0";
  String? token;

  @override
  void initState() {
    super.initState();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    _getUnit(token);
  }

  Future<void> _getUnit(String? token) async {
    final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

    final response = await http.get(
      Uri.parse('$apiUrl/getUnit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['data']);
      setState(() {
        _unit = jsonResponse['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch unit')),
      );
    }
  }

  void _calculateGoal() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    print("weight $weight");
    print("weight ${(weight * 2.20)} pounds");
    double goal = (weight * 2.20) * 0.67;
    print("goal $goal");

    if (_selectedActivityRate == 'Low') {
      goal += _convertWaterUnit(350, 'ml');
    } else if (_selectedActivityRate == 'Moderate') {
      goal += _convertWaterUnit(700, 'ml');
    } else if (_selectedActivityRate == 'High') {
      goal += _convertWaterUnit(1050, 'ml');
    }

    if (_unit == 'ml') {
      goal = _convertWaterUnit(goal, 'oz');
    }
    print("goal after convert $goal");

    setState(() {
      _goal = '${goal.toStringAsFixed(2)} $_unit';
    });
  }

  double _convertWaterUnit(double amount, String fromUnit) {
    if (fromUnit == 'ml') {
      return amount / 29.5735; // Convert ml to oz
    } else {
      return amount * 29.5735; // Convert oz to ml
    }
  }

  void _showNumberPad(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return NumberPad(buttonText: 'CUSTOM GOAL', buttonColor: Colors.lightBlueAccent);
      },
    );

    if (result != null) {
      setState(() {
       _goal = '$result $_unit';
      });
      print(_customGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background images
            Positioned(
              top: 50,
              left: 30,
              child: Image.asset('assets/Flower.png', height: 100), // Flower image
            ),
            Positioned(
              top: 150,
              right: 20,
              child: Image.asset('assets/Glasses-left.png', height: 50), // Glasses left image
            ),
            Positioned(
              top: 300,
              left: 50,
              child: Image.asset('assets/Glasses-right.png', height: 50), // Glasses right image
            ),
            Container(
              color: Color.fromRGBO(88, 210, 255, 1),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/Back.png'), // Custom back button image
                        iconSize: 48,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 75),
                        Image.asset('assets/whiteCactus.png', height: 40), // Replace with your asset
                        SizedBox(height: 10),
                        Text(
                          'Recommended goal',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _goal,
                          style: GoogleFonts.balooThambi2(
                            textStyle: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Your hydration goal',
                          style: GoogleFonts.balooThambi2(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Weight (kg)',
                            hintStyle: GoogleFonts.balooThambi2(
                              textStyle: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.35),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          style: GoogleFonts.balooThambi2(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          onChanged: (value) => _calculateGoal(),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          hint: Text(
                            'Activity Rate',
                            style: GoogleFonts.balooThambi2(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          value: _selectedActivityRate,
                          items: ['Low', 'Moderate', 'High']
                              .map((label) => DropdownMenuItem(
                                    child: Text(
                                      label,
                                      style: GoogleFonts.balooThambi2(
                                        textStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    value: label,
                                  ))
                              .toList(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.35),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectedActivityRate = value!;
                            });
                            _calculateGoal();
                          },
                          dropdownColor: Colors.lightBlueAccent,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Your onPressed function here
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Next'),
                  ),
                  TextButton(
                    onPressed: () => _showNumberPad(context),
                    child: Text(
                      'CUSTOM GOAL',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
