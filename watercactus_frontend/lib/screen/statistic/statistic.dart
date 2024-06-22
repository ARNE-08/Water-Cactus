import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});
  @override
  State<StatefulWidget> createState() => _StatisticPageState();
}

final List<String> imagePaths = [
  'assets/week.png',
  'assets/month.png',
  'assets/average.png',
  'assets/frequency.png',
];

final List<String> texts = [
  'Weekly Average',
  'Monthly Average',
  'Average Completion',
  'Drink Frequency',
];

class _StatisticPageState extends State<StatisticPage> {
  double waterIntake = 0;
  double dailyGoal = 1;
  List<Map<String, dynamic>> weeklyWaterIntake = [];

  @override
  void initState() {
    super.initState();
    fetchWaterIntake();
    fetchWaterGoal();
    fetchWeeklyWaterIntake();
  }

  void fetchWeeklyWaterIntake() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final now = DateTime.now();

    try {
      for (int i = 6; i >= 0; i--) {
        final currentDate = now.subtract(Duration(days: i));
        final startDate =
            DateTime(currentDate.year, currentDate.month, currentDate.day)
                .toIso8601String()
                .split('T')
                .first;
        final endDate = DateTime(currentDate.year, currentDate.month,
                currentDate.day, 23, 59, 59)
            .toIso8601String()
            .split('T')
            .first;

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

        if (response.statusCode == 200) {
          final Map<String, dynamic> fetchedWaterData =
              json.decode(response.body);
          List<dynamic> dynamicList = fetchedWaterData['data'];
          setState(() {
            weeklyWaterIntake.add({
              'date': '${currentDate.day}/${currentDate.month}',
              'waterIntake':
                  dynamicList.isNotEmpty ? dynamicList[0]['total_intake'] : 0,
            });
          });
        } else if (response.statusCode == 204) {
          setState(() {
            weeklyWaterIntake.add({
              'date': '${currentDate.day}/${currentDate.month}',
              'waterIntake': 0,
            });
          });
        } else {
          print(
              'Failed to fetch water data for ${currentDate.day}/${currentDate.month}: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error fetching weekly water data: $error');
    }
  }

  void fetchWaterIntake() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day)
        .toIso8601String()
        .split('T')
        .first;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59)
        .toIso8601String()
        .split('T')
        .first;
    try {
      // Make the HTTP POST request
      print('Tokenn: $token');
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
        final Map<String, dynamic> fetchedWaterData =
            json.decode(response.body);
        print('fetchedd water data: ${fetchedWaterData['data']}');
        // Store the fetched data in the list
        setState(() {
          List<dynamic> dynamicList = fetchedWaterData['data'];
          // print(dynamicList);
          waterIntake = dynamicList[0]['total_intake'];
          // print('waterIntake: $waterIntake');
        });
      } else if (response.statusCode == 204) {
        setState(() {
          waterIntake = 0;
        });
      } else {
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
    final startDate = DateTime(now.year, now.month, now.day)
        .toIso8601String()
        .split('T')
        .first;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59)
        .toIso8601String()
        .split('T')
        .first;
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
        print('fetchedd goal data: ${fetchedGoalData['data']}');
        // Store the fetched data in the list
        setState(() {
          List<dynamic> dynamicList = fetchedGoalData['data'];
          print(dynamicList);
          dailyGoal = dynamicList[0]['goal'];
          print('dailyGoal: $dailyGoal');
        });
      } else if (response.statusCode == 204) {
        setState(() {
          dailyGoal = 1;
        });
      } else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to fetch goal data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching goal data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<TokenProvider>(context).token;
    if (token == null || token.isEmpty) {
      // Redirect to login page if token is null or empty
      Navigator.pushNamed(context, '/login');
      return Container(); // Return an empty container or loading indicator while navigating
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel, color: AppColors.black, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                height: (index == 4 || index == 1)
                    ? 280.0
                    : (index == 2)
                        ? 580.0
                        : 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: index == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/GlassOfWater.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Ideal Water Intake',
                                    style: CustomTextStyle.poppins3.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    '$waterIntake ml',
                                    style: CustomTextStyle.poppins3.copyWith(
                                      fontSize: 12,
                                      color: waterIntake >= dailyGoal ? Colors.blue : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 100,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/trophy.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Water Intake Goal',
                                    style: CustomTextStyle.poppins3.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    '$dailyGoal ml',
                                    style: CustomTextStyle.poppins3.copyWith(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : index == 1
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          PieChart(
                                            PieChartData(
                                              sections: [
                                                PieChartSectionData(
                                                  value: waterIntake,
                                                  color: Colors.blue,
                                                  radius: 20,
                                                ),
                                                PieChartSectionData(
                                                  value:
                                                      dailyGoal - waterIntake,
                                                  color: Colors.grey,
                                                  radius: 20,
                                                ),
                                              ],
                                              centerSpaceRadius: 100,
                                            ),
                                          ),
                                          Text(
                                            '${waterIntake.toStringAsFixed(0)} / $dailyGoal ml',
                                            style: CustomTextStyle.poppins3
                                                .copyWith(
                                              fontSize: 18,
                                              color: waterIntake >= dailyGoal ? Colors.blue : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : index == 2
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Last 7 Days Water Intake',
                                          style: CustomTextStyle.poppins3
                                              .copyWith(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: weeklyWaterIntake.length,
                                        itemBuilder: (context, index) {
                                          // Determine if waterIntake reached dailyGoal
                                          bool reachedGoal =
                                              weeklyWaterIntake[index]
                                                      ['waterIntake'] >=
                                                  dailyGoal;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  '${weeklyWaterIntake[index]['date']}/${DateTime.now().year}',
                                                  style: CustomTextStyle
                                                      .poppins3
                                                      .copyWith(
                                                    fontSize: 12,
                                                    color: reachedGoal
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Water Intake: ${weeklyWaterIntake[index]['waterIntake']} ml',
                                                      style: CustomTextStyle
                                                          .poppins3
                                                          .copyWith(
                                                        fontSize: 12,
                                                        color: reachedGoal
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Daily Goal: ${dailyGoal} ml', // Assuming dailyGoal is a member variable of _StatisticPageState
                                                      style: CustomTextStyle
                                                          .poppins3
                                                          .copyWith(
                                                        fontSize: 12,
                                                        color: reachedGoal
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                color: Colors
                                                    .grey, // Adjust the color as needed
                                                thickness:
                                                    1.0, // Adjust the thickness as needed
                                                height:
                                                    0, // Make sure height is 0 to match ListTile spacing
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ))
                              : index == 3
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 36.0, right: 16.0, bottom: 16),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20),
                                          Expanded(
                                            child: BarChart(
                                              BarChartData(
                                                barGroups: [
                                                  BarChartGroupData(
                                                    x: 0,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 8,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 1,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 10,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 2,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 14,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 3,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 15,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 4,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 9,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 5,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 13,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 6,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 11,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 7,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 12,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 8,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 14,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 9,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 10,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 10,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 7,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                  BarChartGroupData(
                                                    x: 11,
                                                    barRods: [
                                                      BarChartRodData(
                                                        toY: 11,
                                                        color: Colors
                                                            .lightBlueAccent,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                titlesData: FlTitlesData(
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (double value,
                                                              TitleMeta meta) {
                                                        Widget text;
                                                        switch (value.toInt()) {
                                                          case 0:
                                                            text = Text('Ja',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 1:
                                                            text = Text('Fe',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 2:
                                                            text = Text('Ma',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 3:
                                                            text = Text('Ap',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 4:
                                                            text = Text('Ma',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 5:
                                                            text = Text('Ju',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 6:
                                                            text = Text('Ju',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 7:
                                                            text = Text('Au',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 8:
                                                            text = Text('Se',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 9:
                                                            text = Text('Oc',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 10:
                                                            text = Text('No',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          case 11:
                                                            text = Text('De',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                          default:
                                                            text = Text('',
                                                                style: CustomTextStyle
                                                                    .poppins3);
                                                            break;
                                                        }
                                                        return SideTitleWidget(
                                                          axisSide:
                                                              meta.axisSide,
                                                          space: 4,
                                                          child: text,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : index == 4
                                      ? Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Drink Water Report',
                                                style: CustomTextStyle.poppins3
                                                    .copyWith(fontSize: 12),
                                              ),
                                              SizedBox(
                                                  height:
                                                      20), // Add some space below the title
                                              Column(
                                                children: List.generate(4,
                                                    (partIndex) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            imagePaths[
                                                                partIndex],
                                                            width: 40,
                                                            height: 40,
                                                          ),
                                                          SizedBox(width: 8.0),
                                                          Text(
                                                            texts[partIndex],
                                                            style:
                                                                CustomTextStyle
                                                                    .poppins3,
                                                          ),
                                                        ],
                                                      ),
                                                      // Add divider below each row except the last one
                                                      if (partIndex < 3)
                                                        Divider(),
                                                    ],
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          'Chart ${index + 1}',
                                          style: CustomTextStyle.poppins3,
                                        ),
                ),
              );
            }),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(172, 230, 255, 1),
    );
  }
}
