import 'package:flutter/material.dart';
import 'package:watercactus_frontend/screen/auth/login.dart';
import 'package:watercactus_frontend/screen/auth/signup.dart';
import 'package:watercactus_frontend/screen/home/home.dart';
import 'package:watercactus_frontend/screen/profile/waterunit.dart';
import 'package:watercactus_frontend/screen/startup/start.dart';
import 'package:watercactus_frontend/screen/profile/goal_cal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  String? token = await storage.read(key: 'jwt_token');
  bool isTokenStored = token != null && token.isNotEmpty;

  runApp(MyApp(isTokenStored: isTokenStored));
}

class MyApp extends StatelessWidget {
  final bool isTokenStored;

  MyApp({required this.isTokenStored});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterCactus',
      initialRoute: isTokenStored ? '/home' : '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/unit': (context) => UnitPage(),
        '/goal-calculation': (context) => GoalPage(),
        '/home': (context) => HomePage(), // Replace with your actual HomePage widget
      },
    );
  }
}
