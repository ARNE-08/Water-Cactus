import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});
  @override
  State<StatefulWidget> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistic',
          style: CustomTextStyle.poppins3,
        ),
        backgroundColor: Color.fromRGBO(172, 230, 255,100),
      ),
      body: Center(
        child: Text('Statistic Page'),
      ),
      backgroundColor: Color.fromRGBO(172, 230, 255,100),
    );
  }

}