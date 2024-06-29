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
  double dailyGoal = 1;
  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String _unit = "ml";
  String? token;

  Future<String?> getToken() async {
    return Provider.of<TokenProvider>(context, listen: false).token;
  }

  @override
  void initState() {
    super.initState();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    _getUnit(token);
    fetchWaterGoal();
  }

  Future<void> _sendUnit(BuildContext context, String unit, String token) async {
    print("Sending unit with token: $token");
    final responseGoal = await http.post(
      Uri.parse('$apiUrl/addGoal'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'goal': dailyGoal}),
    );

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

  Future<void> _getUnit(String? token) async {

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

  void fetchWaterGoal() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      // Make the HTTP POST request
      // print('Tokenn: $token');
      final response = await http.get(
        Uri.parse('$apiUrl/getGoalToday'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Succeed to fetch goal data: ${response.statusCode}');
        final Map<String, dynamic> fetchedGoalData = json.decode(response.body);
        await _getUnit(token);
        setState(() {
          List<dynamic> dynamicList = fetchedGoalData['data'];
          dailyGoal = dynamicList[0]['goal'];
          print('dailyGoal when fetch: $dailyGoal');
          (_unit == 'ml')
              ? dailyGoal = _convertWaterUnit(dailyGoal, 'ml')
              : dailyGoal = _convertWaterUnit(dailyGoal, 'oz'); // Convert ml to oz
        });
      } else if (response.statusCode == 204) {
        setState(() {
         dailyGoal = 1;
        });
      }
      else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to fetch goal data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching goal data: $error');
    }
  }

  double _convertWaterUnit(double amount, String fromUnit) {
    if (fromUnit == 'ml') {
      return amount / 29.5735; // Convert ml to oz
    } else {
      return amount * 29.5735; // Convert oz to ml
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
                  'assets/Back.png',
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
