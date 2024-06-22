import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/widget/numpad.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String? _selectedGender;
  String? _selectedActivityRate;
  String? _selectedWeather;
  TextEditingController _weightController = TextEditingController();
  String _customGoal = "0";

  void _showNumberPad(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return NumberPad(buttonText: 'CUSTOM GOAL');
      },
    );

    if (result != null) {
      setState(() {
        _customGoal = result;
      });
      print(_customGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(88, 210, 255, 1),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
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
                    '0 ml',
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
                ],
              ),
              SizedBox(height: 40),
              DropdownButtonFormField<String>(
                hint: Text(
                  'Gender',
                  style: GoogleFonts.balooThambi2(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
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
                    _selectedGender = value!;
                  });
                },
                dropdownColor: Colors.lightBlueAccent,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
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
                },
                dropdownColor: Colors.lightBlueAccent,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: Text(
                  'Weather',
                  style: GoogleFonts.balooThambi2(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                value: _selectedWeather,
                items: ['Cold', 'Mild', 'Hot']
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
                    _selectedWeather = value!;
                  });
                },
                dropdownColor: Color.fromARGB(255, 64, 196, 255),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
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
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
