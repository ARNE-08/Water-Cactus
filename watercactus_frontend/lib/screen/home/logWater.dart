import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class LogWaterPage extends StatefulWidget {
  final int beverageIndex;

  LogWaterPage({required this.beverageIndex});

  @override
  State<StatefulWidget> createState() => _LogWaterPageState();
}

class _LogWaterPageState extends State<LogWaterPage> {
  String cactusPath = 'whiteCactus.png';
  bool showShaderMask = true;
  List<String> imagePath = [
    'beverages/Water.png',
    'beverages/Tea.png',
    'beverages/Coffee.png',
    'beverages/Juice.png',
    'beverages/Milk.png',
    'beverages/Soda.png',
    'beverages/Beer.png',
    'beverages/Wine.png',
  ];

  List<Color> maskColor = [
    const Color.fromRGBO(229, 247, 254, 1),
    const Color.fromRGBO(235, 248, 207, 1),
    const Color.fromRGBO(236, 229, 221, 1),
    const Color.fromRGBO(255, 239, 151, 1),
    const Color.fromRGBO(242, 242, 242, 1),
    const Color.fromRGBO(253, 167, 193, 1),
    const Color.fromRGBO(239, 239, 249, 1),
    const Color.fromRGBO(233, 151, 156, 1),
  ];

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
          colors: [Colors.transparent, maskColor[widget.beverageIndex]],
          stops: [0.3, 0.3], // Adjusted stops to fill 80% with blue
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        imagePath[widget.beverageIndex],
        // width: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.cancel, color: AppColors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 20),
          ]),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showShaderMask = !showShaderMask;
                          });
                        },
                        child: showShaderMask
                            ? buildShaderMaskImage()
                            : buildOriginalImage(),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  height: 120,
                  width: double.infinity,
                  // color: AppColors.blue,
                  child: ListView.builder(
                    key: const PageStorageKey('beverageList'),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogWaterPage(
                                  beverageIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                if (index == 0)
                                  Row(children: [
                                    SizedBox(
                                      width: (screenWidth / 2) - 45,
                                    ),
                                    Text(
                                      '330 ml',
                                      style: CustomTextStyle.poppins1,
                                    )
                                  ])
                                else
                                  Column(
                                      children: [
                                        Text(
                                          '330 ml',
                                          style: CustomTextStyle.poppins3,
                                        ),
                                      ]),
                                // SizedBox(height: 10.0),
                              ],
                            ),
                          ));
                    },
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
