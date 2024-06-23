import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/screen/auth/login.dart';
import 'package:watercactus_frontend/screen/auth/signup.dart';
import 'package:watercactus_frontend/screen/home/home.dart';
import 'package:watercactus_frontend/screen/profile/waterunit.dart';
import 'package:watercactus_frontend/screen/startup/start.dart';
import 'package:watercactus_frontend/screen/profile/goal_cal.dart';
import 'package:watercactus_frontend/screen/statistic/statistic.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/screen/profile/profile.dart';
import 'package:watercactus_frontend/screen/profile/edit_profile.dart';
import 'package:watercactus_frontend/screen/profile/noti_setting.dart';
import 'package:watercactus_frontend/screen/home/add_drink.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Flutter Secure Storage
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  runApp(
    ChangeNotifierProvider(
      create: (context) => TokenProvider()..updateToken(token ?? ''),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterCactus',
      theme: CustomTheme.customTheme,
      home: _determineStartPage(context),
      routes: {
        '/stat': (context) => StatisticPage(),
        '/start': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/unit': (context) => UnitPage(),
        '/goal-calculation': (context) => GoalPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/editProfile': (context) => EditProfilePage(),
        '/noti-setting': (context) => NotiSettingPage(),
        '/add-drink': (context) => AddDrinkPage(),
        '/stat': (context) => StatisticPage(),
      },
    );
  }

  Widget _determineStartPage(BuildContext context) {
    String? token = Provider.of<TokenProvider>(context).token;
    if (token != null && token.isNotEmpty) {
      return HomePage();
    } else {
      return StartPage();
    }
  }
}
