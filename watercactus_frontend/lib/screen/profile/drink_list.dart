import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/screen/home/add_drink.dart';
import 'package:watercactus_frontend/screen/home/edit_drink.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:http/http.dart' as http;

class DrinkListPage extends StatefulWidget {
  const DrinkListPage();

  @override
  State<StatefulWidget> createState() => _DrinkListPageState();
}

class _DrinkListPageState extends State<DrinkListPage> {
  String? token;
  final String? apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  List<dynamic> beverageList = [];

  @override
  void initState() {
    super.initState();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    fetchBeverage();
  }

  List<String> imagePaths = [
    'assets/beverageIcons/water.png',
    'assets/beverageIcons/tea.png',
    'assets/beverageIcons/coffee.png',
    'assets/beverageIcons/juice.png',
    'assets/beverageIcons/milk.png',
    'assets/beverageIcons/soda.png',
    'assets/beverageIcons/beer.png',
    'assets/beverageIcons/wine.png',
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
  ];

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

  Future<void> fetchBeverage() async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/getBeverage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'visible': 1,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedBeverageData = json.decode(response.body);
        setState(() {
          beverageList = fetchedBeverageData['data'];
        });
      } else {
        print('Failed to fetch beverageList: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching beverageList: $error');
    }
  }

  void deleteBeverage(int beverageId, String name, int bottleId, int colorId) async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/updateBeverage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'beverage_id': beverageId,
          'name': name,
          'bottle_id': bottleId,
          'color': colorId,
          'visible': 0,
        }),
      );

      if (response.statusCode == 200) {
        print('Success to set visible = 0 : ${response.statusCode}');
        await fetchBeverage();
      } else {
        print('Failed to set visible: ${response.statusCode}');
      }
    } catch (error) {
      print('Error set visible: $error');
    }
  }

  Widget buildAddDrinkImage(int bottleIndex, int colorIndex) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, maskColor[colorIndex]],
          stops: [0.5, 0.5],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        imagePath[bottleIndex],
        width: 50,
        height: 50,
      ),
    );
  }

  List<Widget> buildCard() {
    return beverageList.map((beverage) {
      int index = beverageList.indexOf(beverage);
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 75,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: index < 8
            ? Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset(
                    imagePaths[index],
                    height: 50,
                  ),
                  const SizedBox(width: 25),
                  Text(
                    beverageNames[index],
                    style: CustomTextStyle.poppins6,
                  ),
                ],
              )
            : Row(
                children: [
                  const SizedBox(width: 15),
                  buildAddDrinkImage(beverage['bottle_id'], beverage['color']),
                  const SizedBox(width: 25),
                  Text(
                    beverage['name'].toUpperCase(),
                    style: CustomTextStyle.poppins6,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.border_color_outlined, color: AppColors.black, size: 25),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDrinkPage(
                            token: token,
                            beverageIndex: beverage['beverage_id'],
                            beverageName: beverage['name'],
                            bottleIndex: beverage['bottle_id'],
                            colorIndex: beverage['color'],
                          ),
                        ),
                      );
                      if (result == true) {
                        await fetchBeverage();
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red, size: 30),
                    onPressed: () {
                      deleteBeverage(beverage['beverage_id'], beverage['name'], beverage['bottle_id'], beverage['color']);
                    },
                  ),
                ],
              ),
      );
    }).toList();
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
              Navigator.pushNamed(context, '/profile');
              // Navigator.pop(context);
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              Text('Add Drink List', style: CustomTextStyle.poppins6.copyWith(fontSize: 24)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.brightBlue),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDrinkPage(),
                    ),
                  );
                  if (result == true) {
                    await fetchBeverage();
                  }
                },
                child: Text('+ CREATE NEW DRINK', style: CustomTextStyle.poppins3.copyWith(color: AppColors.white, fontSize: 14)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: buildCard(), // Spread operator to unpack the list of widgets
                  ),
                ),
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
