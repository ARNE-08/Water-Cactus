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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TokenProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<String?> _getToken() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: 'jwt_token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaterCactus',
      theme: CustomTheme.customTheme,
      home: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or any loading widget
          } else {
            String? token = snapshot.data;
            Provider.of<TokenProvider>(context, listen: false).updateToken(token ?? '');
            return _determineStartPage(context);
          }
        },
      ),
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
