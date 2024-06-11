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
        backgroundColor: Color.fromRGBO(172, 230, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                height: 200.0,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/GlassOfWater.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Ideal Water Intake',
                                    style: CustomTextStyle.poppins3,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/trophy.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Water Intake Goal',
                                    style: CustomTextStyle.poppins3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        : index == 2
                          ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last 7 Days Goal Achieve',
                                    style: CustomTextStyle.poppins3,
                                  ),
                                  
                                  
                                ],
                              ),
                          )
                           : index == 4
                          ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drink Water Report',
                                    style: CustomTextStyle.poppins3,
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
