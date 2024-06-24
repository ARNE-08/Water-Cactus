import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/widget/numpad.dart';
import 'package:http/http.dart' as http;


class LogWaterPage extends StatefulWidget {
  String? token;
  final int beverageID;
  final int bottleIndex;
  final int colorIndex;
  final String beverageName;

  LogWaterPage({required this.token, required this.beverageID, required this.bottleIndex, required this.colorIndex, required this.beverageName});

  @override
  State<StatefulWidget> createState() => _LogWaterPageState();
}

class _LogWaterPageState extends State<LogWaterPage> {
  final String? apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String cactusPath = 'assets/whiteCactus.png';
  String _selectedNumber = "0";
  double _totalDragDistance = 0.0;
  final double _threshold = 5.0;
  int _calculatedML = 110;
  int _option1ML = 110;
  int quantity = 110;

  List<String> imagePath = [
    'assets/EmptyBeverages/empty1.png',
    'assets/EmptyBeverages/empty2.png',
    'assets/EmptyBeverages/empty3.png',
    'assets/EmptyBeverages/empty4.png',
    'assets/EmptyBeverages/empty5.png',
    'assets/EmptyBeverages/empty6.png',
    'assets/EmptyBeverages/empty7.png',
    'assets/EmptyBeverages/empty8.png',
  ];

  List<Color> maskColor = [
    AppColors.water,
    AppColors.tea,
    AppColors.coffee,
    AppColors.juice,
    AppColors.milk,
    AppColors.soda,
    AppColors.beer,
    AppColors.wine,
  ];

  int selectedOptionIndex = 1;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addListener(_onScroll);
    });
  }

  void addWater() async {
    final now = DateTime.now();
    final consumeAt = now.toIso8601String();
    final startDate = DateTime(now.year, now.month, now.day).toIso8601String().split('T').first;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String().split('T').first;
    try {
      // Make the HTTP POST request
      // print('Tokenn: ${widget.token}');
      // print('beverageId: ${widget.beverageID}');
      // print('quantity: $quantity');
      // print('consume_at: $consumeAt');
      final response = await http.post(
        Uri.parse('$apiUrl/addWater'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'beverage_id': widget.beverageID,
          'quantity': quantity,
          'consume_at': consumeAt,
        }),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // print('Succeed to fetch water data: ${response.statusCode}');
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('update water data: ${fetchedData['data']}');
        // Store the fetched data in the list

      } else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to add water: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error adding water data: $error');
    }
  }

  void addTotalIntake() async {
    final now = DateTime.now();
    final stat_date = DateTime(now.year, now.month, now.day).toIso8601String().split('T').first;
    try {
      // Make the HTTP POST request
      // print('stat_date: $stat_date');
      // print('quantity: $quantity');
      final response = await http.post(
        Uri.parse('$apiUrl/addTotalIntake'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'stat_date': stat_date,
          'quantity': quantity,
        }),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // print('Succeed to fetch water data: ${response.statusCode}');
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('update intake data: ${fetchedData['data']}');
        // Store the fetched data in the list

      } else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to add intake: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error adding intake data: $error');
    }
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

    for (int index = 0; index < 4; index++) {
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
      _calculatedML = newSelectedIndex == 0 ? 0 : newSelectedIndex == 1 ? 110 : newSelectedIndex == 2 ? 80 : 330;
      quantity = _calculatedML;
    });
  }

  void _onItemTab(int index) {
    // print(index);
    setState(() {
      selectedOptionIndex = index;
      _calculatedML = index == 0 ? 0 : index == 1 ? 110 : index == 2 ? 80 : 330;
      _option1ML = 110;
      quantity = 110;
    });
  }

  double get _calculatedPortion {
    return 1 - (_calculatedML / 330);
  }

  Widget buildShaderMaskImage() {
    return Container(
      height: 400,
      width: 350,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, maskColor[widget.colorIndex]],
            stops: [_calculatedPortion, _calculatedPortion],
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Image.asset(
          imagePath[widget.bottleIndex],
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _showNumberPad(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return NumberPad(buttonText: widget.beverageName, buttonColor: maskColor[widget.colorIndex] ?? AppColors.grey);
      },
    );

    if (result != null) {
      setState(() {
        _selectedNumber = result;
        quantity = int.parse(_selectedNumber);
        addWater();
        addTotalIntake();
        Navigator.pop(context, true);
      });
      // print(_selectedNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final Color? beverageColor = AppColors.beverageColors[widget.beverageName];
      List<String> options = [
        '',
        '${_option1ML.toString()} ml',
        '80ml',
        '330ml',
        // ''
      ];

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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 100),
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                              selectedOptionIndex = 1;
                              _controller.animateTo(
                              0,
                              duration: const Duration(milliseconds: 50),
                              curve: Curves.easeInOut,
                            );
                            // Accumulate the total drag distance
                            _totalDragDistance += details.delta.dy;

                            // Detect if the total drag distance is greater than the threshold
                            if (_totalDragDistance < -_threshold) {
                              setState(() {
                                _calculatedML = (_calculatedML + 10).clamp(0, 330); // Increment by 10 and clamp between 0 and 330
                                _option1ML = _calculatedML;
                                _totalDragDistance = 0; // Reset the drag distance
                                // print('up: $_calculatedML');
                                quantity = _calculatedML;
                              });
                            } else if (_totalDragDistance > _threshold) {
                              setState(() {
                                _calculatedML = (_calculatedML - 10).clamp(0, 330); // Decrement by 10 and clamp between 0 and 330
                                _option1ML = _calculatedML;
                                _totalDragDistance = 0; // Reset the drag distance
                                // print('down: $_calculatedML');
                                quantity = _calculatedML;
                              });
                            }
                          },
                          onVerticalDragEnd: (details) {
                            // Reset the drag distance when the drag ends
                            setState(() {
                              _totalDragDistance = 0;
                              // print(_calculatedML);
                              quantity = _calculatedML;
                            });
                          },
                          child: buildShaderMaskImage(),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 260,
                  width: double.infinity,
                  color: AppColors.lightBlue,
                  child: Column(children: [
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
                    Row(children: [
                      // SizedBox(width: 150),
                      Container(
                        width: (screenWidth / 2) - 80,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(maskColor[widget.colorIndex] ?? AppColors.grey), // Default to grey if beverageColor is null
                        ),
                        onPressed: () {
                          addWater();
                          addTotalIntake();
                          Navigator.pop(context, true);
                        },
                        child: Text('+ ${widget.beverageName.toUpperCase()}'),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => _showNumberPad(context),
                        icon: Icon(Icons.dialpad,
                            color: AppColors.black, size: 30),
                      ),
                      SizedBox(width: 30),
                    ]),
                    SizedBox(
                      height: 50,
                    )
                  ]),
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
