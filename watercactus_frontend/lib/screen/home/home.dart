import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/screen/home/add_drink.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/screen/home/log_water.dart';
import 'package:watercactus_frontend/widget/navbar.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String? apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String cactusPath = 'assets/whiteCactus.png';
  bool showShaderMask = true;
  int waterIntake = 0;
  int dailyGoal = 1;
  String? token;
  List<dynamic> beverageList = [];

  List<String> imagePath = [
    'assets/EmptyBeverages/empty1.png',
    'assets/EmptyBeverages/empty2.png',
    'assets/EmptyBeverages/empty3.png',
    'assets/EmptyBeverages/empty4.png',
    'assets/EmptyBeverages/empty5.png',
    'assets/EmptyBeverages/empty6.png',
    'assets/EmptyBeverages/empty7.png',
    'assets/EmptyBeverages/empty8.png',
  ];

  List<Color> maskColor = [
    AppColors.water,
    AppColors.tea,
    AppColors.coffee,
    AppColors.juice,
    AppColors.milk,
    AppColors.soda,
    AppColors.beer,
    AppColors.wine,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      token = Provider.of<TokenProvider>(context, listen: false).token;
      // print("Tokennnn!: $token");
      if (token != null) {
        fetchWaterIntake();
        fetchWaterGoal();
        fetchBeverage();
      }
    });
  }

  void fetchBeverage() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('$apiUrl/getBeverage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({

        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response directly into a list of maps
        print('Succeed to fetch beverage: ${response.statusCode}');
        final Map<String, dynamic> fetchedBeverageData = json.decode(response.body);
        // print('fetched beverage data: ${fetchedBeverageData['data']}');
        setState(() {
          beverageList = fetchedBeverageData['data'];
          // print('beverageList: $beverageList');
          // print('beverageList length: ${beverageList.length}');
        });
      } else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to fetch beverageList: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching beverageList: $error');
    }
  }

  void fetchWaterIntake() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day).toIso8601String().split('T').first;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String().split('T').first;
    try {
      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('$apiUrl/getWater'),
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
        // print('fetched water data: ${fetchedWaterData['data']}');
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
        Uri.parse('$apiUrl/getGoal'),
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
        // print('fetched goal data: ${fetchedGoalData['data']}');
        // Store the fetched data in the list
        setState(() {
          List<dynamic> dynamicList = fetchedGoalData['data'];
          dailyGoal = dynamicList[0]['goal'];
          // print('dailyGoal: $dailyGoal');
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
      'assets/Cactus.png',
      width: 300,
    );
  }

  double get _calculatedPortion {
    // print('water intake: $waterIntake & daily: $dailyGoal');
    if (waterIntake == dailyGoal) {
      return 0;
    }
    return 1 - (waterIntake / dailyGoal);
  }

  double get _calculatedPercentage {
    // print('water intake: $waterIntake & daily: $dailyGoal');
    double percentage = (waterIntake / dailyGoal) * 100;
    return percentage.roundToDouble();
  }

  Widget buildShaderMaskImage() {
    // print('calculatedPortion: $_calculatedPortion');
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
        'assets/whiteCactus.png',
        width: 300,
      ),
    );
  }

  Widget buildAddDrinkImage(int bottleIndex, int colorIndex) {
  return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, maskColor[colorIndex]], //! ใส่ยังไง
          stops: [0.3, 0.3],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        imagePath[bottleIndex],  //!
        width: 50,
        height: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    List<String> imagePaths = [
      'assets/beverageIcons/water.png',
      'assets/beverageIcons/tea.png',
      'assets/beverageIcons/coffee.png',
      'assets/beverageIcons/juice.png',
      'assets/beverageIcons/milk.png',
      'assets/beverageIcons/soda.png',
      'assets/beverageIcons/beer.png',
      'assets/beverageIcons/wine.png',
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
                                text: '$_calculatedPercentage % of your daily target\n',
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
                          key: const PageStorageKey('beverageList'),  //! fix here
                          scrollDirection: Axis.horizontal,
                          itemCount: beverageList.length + 1,
                          itemBuilder: (context, index) {
                            //! อันเก่า
                            if (index >= 0 && index < 8) {
                              return BeverageOriginalItem(
                                index: index, //! for color
                                token: token,  //! for token
                                beverageNames: beverageNames, //! for name
                                imagePaths: imagePaths,
                                screenWidth: screenWidth,
                                fetchWaterGoal: fetchWaterGoal,
                                fetchWaterIntake: fetchWaterIntake,
                              );
                            //! อันใหม่
                            }
                            else if (index >= 8 && index < beverageList.length){
                              return BeverageNewItem(
                                index: beverageList[index]['beverage_id'],
                                token: token,
                                beverageName: beverageList[index]['name'],
                                bottleIndex: beverageList[index]['bottle_id'],
                                colorIndex: beverageList[index]['color'],
                                screenWidth: screenWidth,
                                fetchWaterGoal: fetchWaterGoal,
                                fetchWaterIntake: fetchWaterIntake,
                                buildAddDrinkImage: buildAddDrinkImage,
                              );
                            }
                            //! Add Water Page
                            else if (index == beverageList.length) {
                              return GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddDrinkPage(),
                                    ),
                                  );
                                  if (result == true) {
                                    fetchBeverage();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/beverageIcons/add.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'ADD',
                                        style: CustomTextStyle.poppins3,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
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

class BeverageOriginalItem extends StatelessWidget {
  final int index;
  final String? token;
  final List<String> beverageNames;
  final List<String> imagePaths;
  final double screenWidth;
  final Function fetchWaterGoal;
  final Function fetchWaterIntake;

  const BeverageOriginalItem({
    Key? key,
    required this.index,
    required this.token,
    required this.beverageNames,
    required this.imagePaths,
    required this.screenWidth,
    required this.fetchWaterGoal,
    required this.fetchWaterIntake,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // print('Token from outter class: $token');
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogWaterPage(
              token: token,
              beverageID: index + 1,
              bottleIndex: index,
              colorIndex: index,
              beverageName: beverageNames[index],
            ),
          ),
        );
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
              Row(
                children: [
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
                            image: AssetImage(imagePaths[index]),
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
                ],
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePaths[index]),
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
  }
}

class BeverageNewItem extends StatelessWidget {
  final int index;
  final String? token;
  final String beverageName;
  final int bottleIndex;
  final int colorIndex;
  final double screenWidth;
  final Function fetchWaterGoal;
  final Function fetchWaterIntake;
  final Function buildAddDrinkImage;

  const BeverageNewItem ({
    Key? key,
    required this.index,
    required this.token,
    required this.beverageName,
    required this.bottleIndex,
    required this.colorIndex,
    required this.screenWidth,
    required this.fetchWaterGoal,
    required this.fetchWaterIntake,
    required this.buildAddDrinkImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogWaterPage(
              token: token,
              beverageID: index,
              bottleIndex: bottleIndex,
              colorIndex: colorIndex,
              beverageName: beverageName,
            ),
          ),
        );
        if (result == true) {
          fetchWaterGoal();
          fetchWaterIntake();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: buildAddDrinkImage(bottleIndex, colorIndex),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    beverageName.toUpperCase(),
                    style: CustomTextStyle.poppins3,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
