import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cactusPath = 'whiteCactus.png';
  ui.Image? cactusImage;

  @override
  void initState() {
    super.initState();
    _loadImage(cactusPath);
  }

  Future<void> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    final List<int> bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image img) {
      setState(() {
        cactusImage = img;
      });
      completer.complete(img);
    });
    await completer.future;
  }

  void _changeImage() {
    setState(() {
      cactusPath = cactusPath == 'assets/whiteCactus.png'
          ? 'assets/Cactus.png'
          : 'assets/whiteCactus.png';
    });
    _loadImage(cactusPath);
  }

  // void _changeImage() {
  //   print('Changing image');
  //   setState(() {
  //     cactusPath =
  //         cactusPath == 'whiteCactus.png' ? 'Cactus.png' : 'whiteCactus.png';
  //   });
  //   print('Image changed to $cactusPath');
  // }

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
                        onTap: _changeImage,
                        // child: Image.asset(cactusPath, width: 300),
                        child: cactusImage == null
                            ? CircularProgressIndicator()
                            : ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return ImageShader(
                                    cactusImage!,
                                    TileMode.clamp,
                                    TileMode.clamp,
                                    Matrix4.identity().storage,
                                  );
                                },
                                blendMode: BlendMode.srcATop,
                                child: Image.asset(
                                  'background.png',
                                  width: 300,
                                ),
                              ),
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
