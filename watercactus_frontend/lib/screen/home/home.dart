import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    List<String> imagePaths = [
      'beverageIcons/water.png',
      'beverageIcons/tea.png',
      'beverageIcons/coffee.png',
      'beverageIcons/juice.png',
      'beverageIcons/milk.png',
      'beverageIcons/soda.png',
      'beverageIcons/beer.png',
      'beverageIcons/wine.png',
      'beverageIcons/add.png',
    ];

    List<String> beverageNames = [
      'WATER',
      'TEA',
      'COFFEE',
      'JUICE',
      'MILK',
      'SODA',
      'BEER',
      'WINE',
      'ADD',
    ];

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '0 ml\n',
                            style: CustomTextStyle.poppins1,
                          ),
                          TextSpan(
                              text: '0% of your daily target\n',
                              style: CustomTextStyle.poppins4),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset('assets/cactus.png', width: 300),
                  ],
                ), // Example cactus image
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            'Stay Hyrated!',
                            style: CustomTextStyle.baloo1,
                          )),
                      Container(
                        height: 120,
                        width: double.infinity,
                        color: AppColors.blue,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(imagePaths[index]),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  beverageNames[index],
                                  style: CustomTextStyle.poppins3,
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
