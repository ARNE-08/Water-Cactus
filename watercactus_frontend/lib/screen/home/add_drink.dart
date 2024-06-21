import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class AddDrinkPage extends StatefulWidget {
  const AddDrinkPage();

  @override
  State<StatefulWidget> createState() => _AddDrinkPageState();
}

class _AddDrinkPageState extends State<AddDrinkPage> {
  List<String> bottleImages = [
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
    'assets/Beverages/Milk.png',
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

  int selectedBottleIndex = 0;
  int selectedColorIndex = 0;

  Widget buildBottleImages(List<String> bottleImages) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        key: const PageStorageKey('bottleImages'),
        scrollDirection: Axis.horizontal,
        itemCount: bottleImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0), // Adjust padding as needed
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
                    fit: BoxFit.cover,
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildShaderMaskImage() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, colors[selectedColorIndex]],
          stops: [0.5, 0.5],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        bottleImages[selectedBottleIndex],
        height: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.lightBlue,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(children: [
            Text('Add Drink List', style: CustomTextStyle.poppins6.copyWith(fontSize: 24)),
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
            Row(children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose bottle', style: CustomTextStyle.poppins4),
                    const SizedBox(height: 10),
                    buildBottleImages(bottleImages),
                    const SizedBox(height: 30),
                    Text('Choose color', style: CustomTextStyle.poppins4),
                    const SizedBox(height: 10),
                    buildColor(colors),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text('Name', style: CustomTextStyle.poppins4),
                          const SizedBox(height: 10),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Beverage Name',
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(height: 40),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.brightBlue), // Default to grey if beverageColor is null
              ),
              onPressed: () {
                // Add your logic here
              },
              child: Text('CONFIRM'),
            ),
          ]),
        ),
      ),
    );
  }
}
