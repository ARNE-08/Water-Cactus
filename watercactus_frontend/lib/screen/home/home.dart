import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cactusPath = 'whiteCactus.png';
  bool showShaderMask = true;

  Widget buildOriginalImage() {
    return Image.asset(
      'Cactus.png',
      width: 300,
    );
  }

  Widget buildShaderMaskImage() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.blue],
          stops: [0.2, 0.2], // Adjusted stops to fill 80% with blue
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        'whiteCactus.png',
        width: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showShaderMask = !showShaderMask;
                          });
                        },
                        child: showShaderMask ? buildShaderMaskImage() : buildOriginalImage(),
                      )
                    ],
                  ),
                ), // Example cactus image
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Stay Hyrated!',
                            style: CustomTextStyle.baloo1,
                          )),
                      Container(
                        height: 120,
                        width: double.infinity,
                        // color: AppColors.blue,
                        child: ListView.builder(
                          // defaultPosition: 50,
                          key: const PageStorageKey('beverageList'),
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
