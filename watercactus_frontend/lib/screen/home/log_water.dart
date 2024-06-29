import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/widget/numpad.dart';
import 'package:http/http.dart' as http;

class LogWaterPage extends StatefulWidget {
  final String? token;
  final int beverageID;
  final int bottleIndex;
  final int colorIndex;
  final String beverageName;
  final String unit;

  LogWaterPage({
    required this.token,
    required this.beverageID,
    required this.bottleIndex,
    required this.colorIndex,
    required this.beverageName,
    required this.unit,
  });

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
  double _calculatedoz = 12;
  double _option1oz = 12;
  int quantity = 0;


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
    (widget.unit == 'ml')
      ? quantity = 110
      : quantity = 355;
    print('quantity: $quantity');
  }

  Future<void> addWater() async {
    final now = DateTime.now();
    final consumeAt = now.toIso8601String();
    try {
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('update water data: ${fetchedData['data']}');
      } else {
        print('Failed to add water: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding water data: $error');
    }
  }

  Future<void> addTotalIntake() async {
    final now = DateTime.now();
    final stat_date = DateTime(now.year, now.month, now.day).toIso8601String().split('T').first;
    try {
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('update intake data: ${fetchedData['data']}');
      } else {
        print('Failed to add intake: ${response.statusCode}');
      }
    } catch (error) {
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
      double itemExtent = 120.0;
      double itemCenter = index * itemExtent + itemExtent / 2;

      double distance = (_controller.offset + center - itemCenter).abs();
      if (distance < minDistance) {
        minDistance = distance;
        newSelectedIndex = index;
      }
    }

    setState(() {
      selectedOptionIndex = newSelectedIndex;
      (widget.unit == 'ml')
          ? _calculatedML = (newSelectedIndex == 0) ? 0 : newSelectedIndex == 1 ? 110 : newSelectedIndex == 2 ? 80 : 330
          : _calculatedoz = (newSelectedIndex == 0) ? 0 : newSelectedIndex == 1 ? 12 : newSelectedIndex == 2 ? 7.1 : 3.7;
      // _calculatedML = (newSelectedIndex == 0) ? 0 : newSelectedIndex == 1 ? 110 : newSelectedIndex == 2 ? 80 : 330;
      (widget.unit == 'ml')
          ? quantity = _calculatedML
          : quantity = (_calculatedoz * 29.5735).toInt();
      // quantity = _calculatedML;
      print('quantity: $quantity');
    });
  }

  void _onItemTab(int index) {
    setState(() {
      selectedOptionIndex = index;
      (widget.unit == 'ml')
          ? _calculatedML = (index == 0) ? 0 : index == 1 ? 110 : index == 2 ? 80 : 330
          : _calculatedoz = (index == 0) ? 0 : index == 1 ? 12 : index == 2 ? 7.1 : 3.7;
      // _calculatedML = (index == 0) ? 0 : index == 1 ? 110 : index == 2 ? 80 : 330;
      (widget.unit == 'ml')
          ? _option1ML = 110
          : _option1oz = 12;
      // _option1ML = 110;
      quantity = (widget.unit == 'ml') ? _calculatedML : (_calculatedoz * 29.5735).toInt();
      print('quantity on Tab: $quantity');
      // quantity = 110;
    });
  }

  double get _calculatedPortion {
    double result = 0;
    (widget.unit == 'ml')
        ? result = 1 - (_calculatedML / 330)
        : result = 1 - (_calculatedoz / 12);
    return (result);
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
        (widget.unit == 'ml')
            ? quantity = int.parse(_selectedNumber)
            : quantity = (int.parse(_selectedNumber) * 29.5735).toInt();
        // quantity = int.parse(_selectedNumber);
      print('quantity: $quantity');
      });
      await addWater();
      await addTotalIntake();
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    List<String> options = (widget.unit == 'ml')
        ? ['', '${_option1ML.toString()} ml', '80 ml', '330 ml']
        : ['', '${_option1oz.toString()} oz', '7.1 oz', '3.7 oz'];

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

                            _totalDragDistance += details.delta.dy;

                            if (_totalDragDistance < -_threshold) {
                              setState(() {
                                (widget.unit == 'ml')
                                    ? _calculatedML = (_calculatedML + 10).clamp(0, 330)
                                    : _calculatedoz = (_calculatedoz + 1).clamp(0, 13);
                                // _calculatedML = (_calculatedML + 10).clamp(0, 330);
                                (widget.unit == 'ml')
                                    ? _option1ML = _calculatedML
                                    : _option1oz = _calculatedoz.ceilToDouble();
                                // _option1ML = _calculatedML;
                                _totalDragDistance = 0;
                                quantity = (widget.unit == 'ml') ? _calculatedML : (_calculatedoz * 29.5735).toInt();
                                print('quantity: $quantity');
                                // quantity = _calculatedML;
                              });
                            } else if (_totalDragDistance > _threshold) {
                              setState(() {
                                (widget.unit == 'ml')
                                    ? _calculatedML = (_calculatedML - 10).clamp(0, 330)
                                    : _calculatedoz = (_calculatedoz - 1).clamp(0, 13);
                                // _calculatedML = (_calculatedML - 10).clamp(0, 330);
                                (widget.unit == 'ml')
                                    ? _option1ML = _calculatedML
                                    : _option1oz = _calculatedoz.ceilToDouble();
                                // _option1ML = _calculatedML;
                                _totalDragDistance = 0;
                                quantity = (widget.unit == 'ml') ? _calculatedML : (_calculatedoz * 29.5735).toInt();
                                print('quantity: $quantity');
                                // quantity = _calculatedML;
                              });
                            }
                          },
                          onVerticalDragEnd: (details) {
                            setState(() {
                              _totalDragDistance = 0;
                              quantity = (widget.unit == 'ml') ? _calculatedML : (_calculatedoz * 29.5735).toInt();
                                print('Here quantity: $quantity');
                              // quantity = _calculatedML;
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
                      Container(
                        width: (screenWidth / 2) - 80,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(maskColor[widget.colorIndex] ?? AppColors.grey),
                        ),
                        onPressed: () async {
                          await addWater();
                          await addTotalIntake();
                          Navigator.pop(context, true);
                        },
                        child: Text('+ ${widget.beverageName.toUpperCase()}'),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () => _showNumberPad(context),
                        icon: Icon(Icons.dialpad, color: AppColors.black, size: 30),
                      ),
                      SizedBox(width: 30),
                    ]),
                    SizedBox(height: 50)
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
