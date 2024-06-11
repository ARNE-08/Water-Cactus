import 'package:flutter/material.dart';
import 'package:watercactus_frontend/screen/auth/login.dart';
import 'package:watercactus_frontend/screen/auth/signup.dart';
import 'package:watercactus_frontend/screen/profile/waterunit.dart';
import 'package:watercactus_frontend/screen/startup/start.dart';
import 'package:watercactus_frontend/screen/statistic/statistic.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check for the presence of the userToken cookie


    return MaterialApp(
      title: 'WaterCactus',
      routes: {
        // '/': (context) => HomePage(),
        //'/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/signup':(context) => SignupPage(),
        '/unit':(context) => UnitPage(),
        '/stat':(context) => StatisticPage(),
        '/':(context) => StatisticPage(),
      },
    );
  }
}