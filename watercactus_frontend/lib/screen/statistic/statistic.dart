import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';

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
  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<TokenProvider>(context).token;
    if (token == null || token.isEmpty) {
      Navigator.pushNamed(context, '/login');
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
                height: (index == 4) ? 280.0 : (index == 2 || index == 1) ? 320.0 : 200.0,
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
                                                  value: 0,
                                                  title: '',
                                                  color: Colors.blue,
                                                  radius: 15,
                                                ),
                                              ].any((section) =>
                                                      section.value != 0)
                                                  ? [
                                                      PieChartSectionData(
                                                        value: 1,
                                                        title: '',
                                                        color: Colors.blue,
                                                        radius: 15,
                                                      ),
                                                      // Add other sections as needed
                                                    ]
                                                  : [
                                                      PieChartSectionData(
                                                        value: 1,
                                                        title: '',
                                                        color: Colors.grey,
                                                        radius: 15,
                                                      ),
                                                    ],
                                              centerSpaceRadius:
                                                  120, // Adjust this value as needed
                                            ),
                                          ),
                                          Text(
                                            '0/3100ml',
                                            style: 
                                                CustomTextStyle.poppins3.copyWith(fontSize: 18),
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
                                          'Last 7 Days Goal Achieve',
                                          style: CustomTextStyle.poppins3.copyWith(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      // First row with 4 pie charts
                                      Row(
                                        children: List.generate(4, (index) {
                                          final List<bool> goalAchieved = [
                                            true,
                                            false,
                                            true,
                                            true,
                                            false,
                                            false,
                                            true
                                          ];

                                          return Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      60, // Adjust width as needed
                                                  height:
                                                      80, // Adjust height as needed
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      PieChart(
                                                        PieChartData(
                                                          sections: [
                                                            PieChartSectionData(
                                                              value: 100,
                                                              title: '',
                                                              color:
                                                                  goalAchieved[
                                                                          index]
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .grey,
                                                              radius: 12,
                                                            ),
                                                          ],
                                                          centerSpaceRadius: 20,
                                                          sectionsSpace: 0,
                                                        ),
                                                        swapAnimationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    150),
                                                      ),
                                                      Image.asset(
                                                        'assets/trophy.png',
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  [
                                                    'S',
                                                    'M',
                                                    'T',
                                                    'W',
                                                    'T',
                                                    'F',
                                                    'S'
                                                  ][index],
                                                  style: CustomTextStyle.poppins3.copyWith(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                      SizedBox(height: 20),
                                      // Second row with 3 pie charts
                                      Row(
                                        children: List.generate(3, (index) {
                                          final List<bool> goalAchieved = [
                                            true,
                                            false,
                                            true,
                                            true,
                                            false,
                                            false,
                                            true
                                          ];

                                          int adjustedIndex = index +
                                              4; // Start index for the second row

                                          return Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      60, // Adjust width as needed
                                                  height:
                                                      80, // Adjust height as needed
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      PieChart(
                                                        PieChartData(
                                                          sections: [
                                                            PieChartSectionData(
                                                              value: 100,
                                                              title: '',
                                                              color: goalAchieved[
                                                                      adjustedIndex]
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                              radius: 12,
                                                            ),
                                                          ],
                                                          centerSpaceRadius: 20,
                                                          sectionsSpace: 0,
                                                        ),
                                                        swapAnimationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    150),
                                                      ),
                                                      Image.asset(
                                                        'assets/trophy.png',
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  [
                                                    'S',
                                                    'M',
                                                    'T',
                                                    'W',
                                                    'T',
                                                    'F',
                                                    'S'
                                                  ][adjustedIndex],
                                                  style: CustomTextStyle.poppins3.copyWith(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                )
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
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 1:
                                                            text = Text('Fe',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 2:
                                                            text = Text('Ma',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 3:
                                                            text = Text('Ap',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 4:
                                                            text = Text('Ma',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 5:
                                                            text = Text('Ju',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 6:
                                                            text = Text('Ju',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 7:
                                                            text = Text('Au',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 8:
                                                            text = Text('Se',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 9:
                                                            text = Text('Oc',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 10:
                                                            text = Text('No',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          case 11:
                                                            text = Text('De',
                                                                style: CustomTextStyle.poppins3);
                                                            break;
                                                          default:
                                                            text = Text('',
                                                                style: CustomTextStyle.poppins3);
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
                                                style: CustomTextStyle.poppins3.copyWith(fontSize: 12),
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
