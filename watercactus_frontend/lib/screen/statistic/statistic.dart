import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

class _StatisticPageState extends State<StatisticPage> {
  String? token;
  double waterIntake = 0;
  double dailyGoal = 1;
  List<Map<String, dynamic>> weeklyWaterIntake = [];
  Map<String, double> monthlyWaterIntake = {};
  String _unit = "ml";

  Future<String?> getToken() async {
    return Provider.of<TokenProvider>(context, listen: false).token;
  }

  @override
  void initState() {
    token = Provider.of<TokenProvider>(context, listen: false).token;
    if (token != null) {
      super.initState();
      fetchWaterIntake();
      fetchWaterGoal();
      fetchWeeklyWaterIntake();
      fetchMonthlyWaterIntake();
      _getUnit(token);
    }
  }

  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

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
      // print(jsonResponse['data']);
      setState(() {
        _unit = jsonResponse['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch unit')),
      );
    }
  }

  String calculateWaterIntake(double amount) {
    if (_unit == 'ml') {
      return amount.toStringAsFixed(2);
    } else {
      return (amount / 29.5735).toStringAsFixed(1); // Convert ml to oz
    }
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

        // Fetch daily goal for the current day
        final goalResponse = await http.get(
          Uri.parse('$apiUrl/getGoalToday'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        // Fetch water intake data for the current day
        final waterResponse = await http.post(
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

        if (goalResponse.statusCode == 200 && waterResponse.statusCode == 200) {
          final Map<String, dynamic> fetchedGoalData =
              json.decode(goalResponse.body);
          final Map<String, dynamic> fetchedWaterData =
              json.decode(waterResponse.body);

          List<dynamic> goalDataList = fetchedGoalData['data'];
          List<dynamic> waterDataList = fetchedWaterData['data'];

          double dailyGoal =
              goalDataList.isNotEmpty ? goalDataList[0]['goal'] : 1;
          double waterIntake =
              waterDataList.isNotEmpty ? waterDataList[0]['total_intake'] : 0;
          print("--------------------");
          print('Fetched data for ${currentDate.day}/${currentDate.month}:');
          print('Daily Goal: $dailyGoal');
          print('Daily Water Intake: $waterIntake');

          setState(() {
            weeklyWaterIntake.add({
              'date': '${currentDate.day}/${currentDate.month}',
              'waterIntake': waterIntake,
              'dailyGoal': dailyGoal,
            });
          });
        } else if (goalResponse.statusCode == 204) {
          setState(() {
            // If no goal data found, default to 1
            weeklyWaterIntake.add({
              'date': '${currentDate.day}/${currentDate.month}',
              'waterIntake': 0,
              'dailyGoal': 1,
            });
          });
        } else {
          print(
              'Failed to fetch data for ${currentDate.day}/${currentDate.month}');
        }
      }
    } catch (error) {
      print('Error fetching weekly water data: $error');
    }
  }

  void fetchMonthlyWaterIntake() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final now = DateTime.now();

    for (int month = 1; month <= 12; month++) {
      final startDate =
          DateTime(now.year, month, 1).toIso8601String().split('T').first;
      final endDate = DateTime(now.year, month + 1, 0, 23, 59, 59)
          .toIso8601String()
          .split('T')
          .first;

      try {
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

        print('Request for month $month: ${response.statusCode}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> fetchedWaterData =
              json.decode(response.body);
          List<dynamic> waterEntries = fetchedWaterData['data'];
          double totalIntake = 0;

          for (var entry in waterEntries) {
            totalIntake += entry['total_intake'];
          }

          setState(() {
            monthlyWaterIntake[
                    '${DateTime(now.year, month).month}/${DateTime(now.year, month).year}'] =
                totalIntake;
          });
        } else if (response.statusCode == 204) {
          setState(() {
            monthlyWaterIntake[
                '${DateTime(now.year, month).month}/${DateTime(now.year, month).year}'] = 0;
          });
        } else {
          print(
              'Failed to fetch water data for month $month: ${response.statusCode}');
          print('Response body: ${response.body}');
          // Handle other status codes as needed
        }
      } catch (error) {
        print('Error fetching water data for month $month: $error');
        // Handle any other errors that occur during the process
      }
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
      //print('Tokenn: $token');
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
        final Map<String, dynamic> fetchedWaterData =
            json.decode(response.body);
        print('fetchedd water data: ${fetchedWaterData['data']}');
        //_printToken();
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

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response directly into a list of maps
        print('Succeed to fetch goal data: ${response.statusCode}');
        final Map<String, dynamic> fetchedGoalData = json.decode(response.body);
        // print('fetched goal data: ${fetchedGoalData['data']}');
        // Store the fetched data in the list
        await _getUnit(token);
        setState(() {
          List<dynamic> dynamicList = fetchedGoalData['data'];
          dailyGoal = dynamicList[0]['goal'];
          print('dailyGoal: $dailyGoal');
          (_unit == 'ml')
              ? dailyGoal = dailyGoal
              : dailyGoal = (dailyGoal * 29.5735); // Convert ml to oz
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

  double calculateWeeklyAverage() {
    if (weeklyWaterIntake.isEmpty) return 0; // Error: 0 is an int, not a double

    double totalIntake = 0;
    for (var entry in weeklyWaterIntake) {
      totalIntake += entry['waterIntake'];
    }

    // Calculate average
    double weeklyAverage = totalIntake / weeklyWaterIntake.length;

    // Optionally, round to two decimal places
    return weeklyAverage; // No need for toStringAsFixed(2) here
  }

  double calculateCurrentMonthAverage() {
    if (monthlyWaterIntake.isEmpty) return 0.0;

    // Get the current month and year
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final daysInCurrentMonth = now.day;

    double totalIntake = 0.0;
    int entryCount = 0;

    // Print the current month and year for debugging
    print('Current month: $currentMonth, Current year: $currentYear');

    // Iterate over the monthlyWaterIntake to sum up the intake for the current month
    monthlyWaterIntake.forEach((date, intake) {
      print('Checking date: $date'); // Debug print
      List<String> dateParts = date.split('/');
      if (dateParts.length == 2) {
        int month = int.parse(dateParts[0]);
        int year = int.parse(dateParts[1]);
        print('Year: $year, Month: $month'); // Debug print

        if (year == currentYear && month == currentMonth) {
          totalIntake += intake;
          entryCount++;
          print('Included date: $date, Intake: $intake'); // Debug print
        }
      } else {
        print('Invalid date format: $date'); // Debug print for invalid dates
      }
    });

    if (entryCount == 0) {
      print('No data for the current month'); // Debug print
      return 0.0; // Avoid division by zero
    }

    // Calculate the average daily intake for the current month
    double dailyAverageIntake = totalIntake / daysInCurrentMonth;
    print(
        'Total intake: $totalIntake, Days in month: $daysInCurrentMonth, Daily average intake: $dailyAverageIntake'); // Debug print

    return dailyAverageIntake;
  }

  double calculateCompletionPercentage() {
    if (weeklyWaterIntake.isEmpty)
      return 0; // Handle edge case when there's no data

    int successfulDays = 0;

    weeklyWaterIntake.forEach((entry) {
      double waterIntake = entry['waterIntake'];
      double dailyGoal = entry['dailyGoal'];

      if (_unit == 'ml') {
        if (waterIntake >= dailyGoal) {
          successfulDays++;
        }
      } else {
        // Convert daily intake from ml to oz if the unit is oz
        double waterIntakeInOz = waterIntake / 29.5735; // 1 ml = 0.033814 oz
        if (waterIntakeInOz >= dailyGoal) {
          successfulDays++;
        }
      }
    });

    // Calculate percentage of days that met their daily goal
    double completionPercentage =
        (successfulDays / weeklyWaterIntake.length) * 100;

    // Optionally, round to two decimal places
    return completionPercentage;
  }

  int calculateSuccessFrequency() {
    if (weeklyWaterIntake.isEmpty) return 0;

    int successFrequency = 0;
    weeklyWaterIntake.forEach((entry) {
      double waterIntake = entry['waterIntake'];
      double dailyGoal = entry['dailyGoal'];

      if (_unit == 'oz') {
        // Convert water intake to oz if the unit is oz
        waterIntake = waterIntake / 29.5735; // 1 ml = 0.033814 oz
      }

      // Compare water intake with daily goal
      if (waterIntake >= dailyGoal) {
        successFrequency++;
      }
    });

    return successFrequency;
  }

  Future<void> _printToken() async {
    String? token = await getToken();
    if (token != null) {
      print("Token: $token");
    } else {
      print("No token found");
    }
  }

  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<TokenProvider>(context).token;
    if (token == null || token.isEmpty) {
      // Redirect to login page if token is null or empty
      Navigator.pushNamed(context, '/home');
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
                    : (index == 3)
                        ? 900.0
                        : (index == 2)
                            ? 580.0
                            : 150.0,
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
                                    'Ideal Water Intake ',
                                    style: CustomTextStyle.poppins3.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    '${calculateWaterIntake(waterIntake)} ${_unit == 'ml' ? 'ml' : 'oz'}',
                                    style: CustomTextStyle.poppins3.copyWith(
                                      fontSize: 12,
                                      color: waterIntake >= dailyGoal
                                          ? Colors.blue
                                          : Colors.black,
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
                                    '${calculateWaterIntake(dailyGoal)} ${_unit == 'ml' ? 'ml' : 'oz'}',
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
                                              sections: waterIntake > dailyGoal
                                                  ? [
                                                      PieChartSectionData(
                                                        value: dailyGoal,
                                                        color: Colors.blue,
                                                        radius: 20,
                                                        showTitle: false,
                                                      ),
                                                    ]
                                                  : [
                                                      PieChartSectionData(
                                                        value: waterIntake,
                                                        color: Colors.blue,
                                                        radius: 20,
                                                        showTitle: false,
                                                      ),
                                                      PieChartSectionData(
                                                        value: dailyGoal -
                                                            waterIntake,
                                                        color: Colors.grey,
                                                        radius: 20,
                                                        showTitle: false,
                                                      ),
                                                    ],
                                              centerSpaceRadius: 100,
                                            ),
                                          ),
                                          Text(
                                            '${calculateWaterIntake(waterIntake)} / ${calculateWaterIntake(dailyGoal)} ${_unit == 'ml' ? 'ml' : 'oz'}',
                                            style: CustomTextStyle.poppins3
                                                .copyWith(
                                              fontSize: 18,
                                              color: waterIntake >= dailyGoal
                                                  ? Colors.blue
                                                  : Colors.black,
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last 7 days Hydration Intake ',
                                        style: CustomTextStyle.poppins3
                                            .copyWith(
                                                fontSize: 12,
                                                color: Colors.black),
                                      ),
                                      SizedBox(height: 20),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: weeklyWaterIntake.length,
                                        itemBuilder: (context, index) {
                                          double dailyGoal =
                                              weeklyWaterIntake[index]
                                                  ['dailyGoal'];
                                          bool reachedGoal;
                                          double waterIntake =
                                              weeklyWaterIntake[index]
                                                  ['waterIntake'];

                                          if (_unit == 'ml') {
                                            reachedGoal =
                                                waterIntake >= dailyGoal;
                                          } else {
                                            // Convert daily intake from ml to oz if the unit is oz
                                            double waterIntakeInOz = waterIntake /
                                                29.5735; // 1 ml = 0.033814 oz
                                            reachedGoal =
                                                waterIntakeInOz >= dailyGoal;
                                          }

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      'Daily Intake: ${calculateWaterIntake(waterIntake)} $_unit',
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
                                                      'Daily Goal: $dailyGoal $_unit',
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
                                                color: Colors.grey,
                                                thickness: 1.0,
                                                height: 0,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : index == 3
                                  ? Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Monthly Hydration Intake',
                                            style: CustomTextStyle.poppins3
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: monthlyWaterIntake.keys
                                                .map((key) => Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Text(
                                                            key,
                                                            style:
                                                                CustomTextStyle
                                                                    .poppins3
                                                                    .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Monthly Intake:',
                                                              style:
                                                                  CustomTextStyle
                                                                      .poppins3
                                                                      .copyWith(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${calculateWaterIntake(monthlyWaterIntake[key] ?? 0.0)} ${_unit == 'ml' ? 'ml' : 'oz'}',
                                                              style:
                                                                  CustomTextStyle
                                                                      .poppins3
                                                                      .copyWith(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 0.5,
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    )
                                  : index == 4
                                      ? Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Drink Water Report',
                                                style: CustomTextStyle.poppins3
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                              ),
                                              SizedBox(height: 20),

                                              // Last 7 Days Average
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/week.png', // Replace with your image path
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        'Weekly Average',
                                                        style: CustomTextStyle
                                                            .poppins3,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${calculateWaterIntake(calculateWeeklyAverage())} ${_unit == 'ml' ? 'ml' : 'oz'}',
                                                    style: CustomTextStyle
                                                        .poppins3,
                                                  ),
                                                ],
                                              ),
                                              Divider(),

                                              // Monthly Average
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/month.png', // Replace with your image path
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        'Monthly Average',
                                                        style: CustomTextStyle
                                                            .poppins3,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${calculateWaterIntake(calculateCurrentMonthAverage())} ${_unit == 'ml' ? 'ml' : 'oz'}',
                                                    style: CustomTextStyle
                                                        .poppins3,
                                                  ),
                                                ],
                                              ),
                                              Divider(),

                                              // Average Completion
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/average.png', // Replace with your image path
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        'Average Completion',
                                                        style: CustomTextStyle
                                                            .poppins3,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${calculateCompletionPercentage().toStringAsFixed(2)} %',
                                                    style: CustomTextStyle
                                                        .poppins3,
                                                  ),
                                                ],
                                              ),
                                              Divider(),

                                              // Success Frequency (You can display relevant data here)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/frequency.png', // Replace with your image path
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        'Success Frequency',
                                                        style: CustomTextStyle
                                                            .poppins3,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${calculateSuccessFrequency()} times',
                                                    style: CustomTextStyle
                                                        .poppins3,
                                                  ),
                                                ],
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
