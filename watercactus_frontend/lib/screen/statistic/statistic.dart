import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:fl_chart/fl_chart.dart';

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
                height: index == 4 ? 280.0 : 200.0,
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
                                      child: PieChart(
                                        PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value: 20,
                                              title: '',
                                              color: Colors.blue,
                                              radius: 10,
                                            ),
                                          ].any((section) => section.value != 0)
                                              ? [
                                                  PieChartSectionData(
                                                    value: 10,
                                                    title: '',
                                                    color: Colors.blue,
                                                    radius: 10,
                                                  ),
                                                  // Add other sections as needed
                                                ]
                                              : [
                                                  PieChartSectionData(
                                                    value: 1,
                                                    title: '',
                                                    color: Colors.grey,
                                                    radius: 10,
                                                  ),
                                                ],
                                        ),
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
                                    children: [
                                      Text(
                                        'Last 7 Days Goal Achieve',
                                        style: CustomTextStyle.poppins3,
                                      ),
                                    ],
                                  ),
                                )
                              : index == 3
                                  ? Padding(
  padding: const EdgeInsets.all(20.0),
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
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 10,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 14,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: 15,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                    toY: 9,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 5,
                barRods: [
                  BarChartRodData(
                    toY: 13,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 6,
                barRods: [
                  BarChartRodData(
                    toY: 11,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 7,
                barRods: [
                  BarChartRodData(
                    toY: 12,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 8,
                barRods: [
                  BarChartRodData(
                    toY: 14,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 9,
                barRods: [
                  BarChartRodData(
                    toY: 10,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 10,
                barRods: [
                  BarChartRodData(
                    toY: 7,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 11,
                barRods: [
                  BarChartRodData(
                    toY: 11,
                    color: Colors.lightBlueAccent,
                  ),
                ],
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const style = TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                    Widget text;
                    switch (value.toInt()) {
                      case 0:
                        text = Text('Ja', style: style);
                        break;
                      case 1:
                        text = Text('Fe', style: style);
                        break;
                      case 2:
                        text = Text('Ma', style: style);
                        break;
                      case 3:
                        text = Text('Ap', style: style);
                        break;
                      case 4:
                        text = Text('Ma', style: style);
                        break;
                      case 5:
                        text = Text('Ju', style: style);
                        break;
                      case 6:
                        text = Text('Ju', style: style);
                        break;
                      case 7:
                        text = Text('Au', style: style);
                        break;
                      case 8:
                        text = Text('Se', style: style);
                        break;
                      case 9:
                        text = Text('Oc', style: style);
                        break;
                      case 10:
                        text = Text('No', style: style);
                        break;
                      case 11:
                        text = Text('De', style: style);
                        break;
                      default:
                        text = Text('', style: style);
                        break;
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
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
                                            style: CustomTextStyle.poppins3,
                                          ),
                                          SizedBox(height: 20), // Add some space below the title
                                          Column(
                                            children: List.generate(4, (partIndex) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        imagePaths[partIndex],
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      SizedBox(width: 8.0),
                                                      Text(
                                                        texts[partIndex],
                                                        style: CustomTextStyle.poppins3,
                                                      ),
                                                    ],
                                                  ),
                                                  // Add divider below each row except the last one
                                                  if (partIndex < 3) Divider(),
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
