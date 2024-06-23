import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/screen/home/log_water.dart';
import 'package:watercactus_frontend/widget/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cactusPath = 'whiteCactus.png';
  bool showShaderMask = true;
  int waterIntake = 0;
  int dailyGoal = 1;
  String? token;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWaterIntake();
      fetchWaterGoal();
    });
    token = Provider.of<TokenProvider>(context, listen: false).token;
    // print("Tokennnn: $token");
  }
  void fetchWaterIntake() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day).toIso8601String().split('T').first;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String().split('T').first;
    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('http://localhost:3000/getWater'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'startDate': startDate,
          'endDate': endDate,
        }),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response directly into a list of maps
        // print('Succeed to fetch water data: ${response.statusCode}');
        final Map<String, dynamic> fetchedWaterData = json.decode(response.body);
        print('fetched water data: ${fetchedWaterData['data']}');
        // Store the fetched data in the list
        setState(() {
          List<dynamic> dynamicList = fetchedWaterData['data'];
          waterIntake = dynamicList[0]['total_intake'];
          // print('waterIntake: $waterIntake');
        });
      } else if (response.statusCode == 204) {
        setState(() {
          waterIntake = 0;
        });
      }
      else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to fetch water data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching water data: $error');
    }
  }

  void fetchWaterGoal() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day).toIso8601String().split('T').first;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String().split('T').first;
    try {
      // Make the HTTP POST request
      // print('Tokenn: $token');
      final response = await http.post(
        Uri.parse('http://localhost:3000/getGoal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'startDate': startDate,
          'endDate': endDate,
        }),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response directly into a list of maps
        print('Succeed to fetch goal data: ${response.statusCode}');
        final Map<String, dynamic> fetchedGoalData = json.decode(response.body);
        print('fetched goal data: ${fetchedGoalData['data']}');
        // Store the fetched data in the list
        setState(() {
          List<dynamic> dynamicList = fetchedGoalData['data'];
          dailyGoal = dynamicList[0]['goal'];
          print('dailyGoal: $dailyGoal');
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

  Widget buildOriginalImage() {
    return Image.asset(
      'Cactus.png',
      width: 300,
    );
  }

  double get _calculatedPortion {
    return 1 - (waterIntake / dailyGoal);
  }

  double get _calculatedPercentage {
    // print('water intake: $waterIntake & daily: $dailyGoal');
    double percentage = (waterIntake / dailyGoal) * 100;
    return percentage.roundToDouble();
  }

  Widget buildShaderMaskImage() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.blue],
          stops: [_calculatedPortion, _calculatedPortion],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        'whiteCactus.png',
        width: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    List<String> imagePaths = [
      'beverageIcons/water.png',
      'beverageIcons/tea.png',
      'beverageIcons/coffee.png',
      'beverageIcons/juice.png',
      'beverageIcons/milk.png',
      'beverageIcons/soda.png',
      'beverageIcons/beer.png',
      'beverageIcons/wine.png',
      'beverageIcons/add.png',
    ];

    List<String> beverageNames = [
      'WATER',
      'TEA',
      'COFFEE',
      'JUICE',
      'MILK',
      'SODA',
      'BEER',
      'WINE',
      'ADD',
    ];

    return Scaffold(
      appBar: Navbar(),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$waterIntake ml\n',
                                style: CustomTextStyle.poppins1,
                              ),
                              TextSpan(
                                text: '0% of your daily target\n',
                                style: CustomTextStyle.poppins4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showShaderMask = !showShaderMask;
                            });
                          },
                          child: showShaderMask
                              ? buildShaderMaskImage()
                              : buildOriginalImage(),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 290,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Stay Hydrated!',
                          style: CustomTextStyle.baloo1,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 180,
                        width: double.infinity,
                        child: ListView.builder(
                          key: const PageStorageKey('beverageList'),
                          scrollDirection: Axis.horizontal,
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogWaterPage(
                                      token: token,
                                      beverageIndex: index,
                                      beverageName: beverageNames[index],
                                    ),
                                  ),
                                );
                                // print('pop result: $result');
                                if (result == true) {
                                  fetchWaterGoal();
                                  fetchWaterIntake();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    if (index == 0)
                                      Row(children: [
                                        SizedBox(
                                          width: (screenWidth / 2) - 45,
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      imagePaths[index]),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              beverageNames[index],
                                              style: CustomTextStyle.poppins3,
                                            ),
                                          ],
                                        ),
                                      ])
                                    else
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    imagePaths[index]),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            beverageNames[index],
                                            style: CustomTextStyle.poppins3,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
