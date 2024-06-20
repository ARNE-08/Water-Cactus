import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/widget/numpad.dart';

class LogWaterPage extends StatefulWidget {
  final int beverageIndex;
  final String beverageName;

  LogWaterPage({required this.beverageIndex, required this.beverageName});

  @override
  State<StatefulWidget> createState() => _LogWaterPageState();
}

class _LogWaterPageState extends State<LogWaterPage> {
  String cactusPath = 'whiteCactus.png';
  bool showShaderMask = true;
  String _selectedNumber = "0";

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

  int selectedOptionIndex = 1;
  final ScrollController _controller = ScrollController();
  List<String> options = [
    '',
    '100ml',
    '200ml',
    '300ml',
    // ''
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
  double center = _controller.position.viewportDimension / 2;
  double minDistance = double.infinity;
  int newSelectedIndex = selectedOptionIndex;

  for (int index = 0; index < options.length; index++) {
    double itemExtent = 120.0; // Adjust according to the size of your items
    double itemCenter = index * itemExtent + itemExtent / 2;

    double distance = (_controller.offset + center - itemCenter).abs();
    if (distance < minDistance) {
      minDistance = distance;
      newSelectedIndex = index;
    }
  }

  setState(() {
    selectedOptionIndex = newSelectedIndex;
  });
}
  void _onItemTab(int index) {
    print(index);
    setState( () {
      selectedOptionIndex = index;
    }
    );
  }

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
        height: 460,
      ),
    );
  }

  void _showNumberPad(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return NumberPad();
      },
    );

    if (result != null) {
      setState(() {
        _selectedNumber = result;
      });
      print(_selectedNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final Color? beverageColor = AppColors.beverageColors[widget.beverageName];
    print('color: $beverageColor');

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
                SizedBox(height: 20),
                Container(
                  height: 260,
                  width: double.infinity,
                  color: AppColors.lightBlue,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final isSelected = index == selectedOptionIndex;

                            return GestureDetector(
                              onTap: () => _onItemTab(index),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 55.0),
                                child: Text(
                                  option,
                                  style: isSelected
                                      ? CustomTextStyle.poppins1
                                      : CustomTextStyle.poppins5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          // SizedBox(width: 150),
                          Container(
                            width: (screenWidth / 2) - 80,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                               fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                               backgroundColor: MaterialStateProperty.all<Color>(beverageColor ?? AppColors.grey), // Default to grey if beverageColor is null
                            ),
                            onPressed: () {

                            },
                            child: Text('+ ${widget.beverageName}'),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () => _showNumberPad(context),
                             icon: Icon(Icons.dialpad, color: AppColors.black, size: 30),
                          ),
                          SizedBox(width: 30),
                        ]
                      ),
                      SizedBox(height: 50,)
                    ]
                  ),
                ),
                // SizedBox(width: screenWidth / 2), // Space to center the selected option
              ],
            ),
          ),
        ],
      ),
    );
  }
}
