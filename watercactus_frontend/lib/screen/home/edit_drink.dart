import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:http/http.dart' as http;

class EditDrinkPage extends StatefulWidget {
  String? token;
  final int beverageIndex;
  final int bottleIndex;
  final int colorIndex;
  final String beverageName;

  EditDrinkPage({required this.token, required this.beverageIndex, required this.bottleIndex, required this.colorIndex, required this.beverageName});

  @override
  State<StatefulWidget> createState() => _EditDrinkPageState();
}

class _EditDrinkPageState extends State<EditDrinkPage> {
  final String? apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  int selectedBottleIndex = 0;
  int selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedBottleIndex = widget.bottleIndex;
    selectedColorIndex = widget.colorIndex;
    _nameController.text = widget.beverageName;
  }

  List<String> bottleImages = [
    'assets/EmptyBeverages/empty1.png',
    'assets/EmptyBeverages/empty2.png',
    'assets/EmptyBeverages/empty3.png',
    'assets/EmptyBeverages/empty4.png',
    'assets/EmptyBeverages/empty5.png',
    'assets/EmptyBeverages/empty6.png',
    'assets/EmptyBeverages/empty7.png',
    'assets/EmptyBeverages/empty8.png',
  ];

  List<Color> colors = [
    AppColors.water,
    AppColors.tea,
    AppColors.coffee,
    AppColors.juice,
    AppColors.milk,
    AppColors.soda,
    AppColors.beer,
    AppColors.wine,
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  void updateBeverage(String name, int bottleId, int colorId) async {
    // print('token from list page: ${widget.token}');
    // print('b_id: ${widget.beverageIndex}');
    // print('name: ${name}');
    // print('bottle_id: ${bottleId}');
    // print('color: ${colorId}');
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/updateBeverage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'beverage_id': widget.beverageIndex,
          'name': name,
          'bottle_id': bottleId,
          'color': colorId,
          'visible': 1,
        }),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Succeed to add drink: ${response.statusCode}');
      } else {
        // Handle other status codes (e.g., 400, 401, etc.)
        print('Failed to add drink: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error adding drink $error');
    }
  }

  Widget buildBottleImages(List<String> bottleImages) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        key: const PageStorageKey('bottleImages'),
        scrollDirection: Axis.horizontal,
        itemCount: bottleImages.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedBottleIndex == index ? AppColors.darkGrey : AppColors.white,
                width: 2.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Adjust padding as needed
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBottleIndex = index;
                  });
                },
                child: SizedBox(
                  height: 65,
                  width: 65,
                  child: ClipOval(
                    child: Image.asset(
                      bottleImages[index], // Use the image URL or path from the list
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildColor(List<Color> colors) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        key: const PageStorageKey('colors'),
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0), // Adjust padding as needed
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedColorIndex = index;
                });
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedColorIndex == index ? AppColors.white : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildShaderMaskImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, colors[selectedColorIndex]],
              stops: [0.6, 0.6],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset(
            bottleImages[selectedBottleIndex],
            height: 100,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                Text('Edit Drink List', style: CustomTextStyle.poppins6.copyWith(fontSize: 24)),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: ClipOval(
                        child: buildShaderMaskImage(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Choose bottle', style: CustomTextStyle.poppins4),
                          const SizedBox(height: 20),
                          buildBottleImages(bottleImages),
                          const SizedBox(height: 30),
                          Text('Choose color', style: CustomTextStyle.poppins4),
                          const SizedBox(height: 10),
                          buildColor(colors),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 25),
                                  Text('Name', style: CustomTextStyle.poppins4),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: widget.beverageName,
                                      hintStyle: CustomTextStyle.poppins6.copyWith(color: AppColors.grey),
                                      prefixIcon: const Icon(Icons.coffee, color: Colors.white),
                                      contentPadding: const EdgeInsets.only(left: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    style: CustomTextStyle.poppins6,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all<Size>(Size(140, 50)),
                    backgroundColor: WidgetStateProperty.all<Color>(AppColors.brightBlue),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add your logic here
                      // print('Form is valid, proceed further');
                      updateBeverage(_nameController.text, selectedBottleIndex, selectedColorIndex);
                      Navigator.pop(context, true);
                    } else {
                      // print('Form is invalid');
                    }
                  },
                  child: Text('CONFIRM'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
