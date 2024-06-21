import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/widget/cardCarousel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    final List<CardData> cardList = [ // List of CardData objects defined here
      CardData(title: 'Water Scarcity', detail: 'Water scarcity affects more than 40% of people around the world, an alarming figure that is projected to increase with the rise of global temperatures as a consequence of climate change.' ),
      CardData(title: 'Water Quality', detail: 'Access to clean and safe drinking water is a human right, yet billions of people still lack access to basic water services. Improving water quality is essential for human health, environmental sustainability, and economic development.' ),
      CardData(title: 'Water and Agriculture', detail: 'Water is crucial for agriculture, which is the largest consumer of water globally. Efficient water management practices are essential to ensure food security, sustainable agricultural production, and rural development.' ),
      CardData(title: 'Water and Climate Change', detail: 'Climate change exacerbates water-related challenges such as floods, droughts, and water scarcity. Addressing climate change impacts on water resources is essential for achieving sustainable development and resilience.' ),
      CardData(title: 'Water and Gender Equality', detail: 'Women and girls are disproportionately affected by water scarcity and lack of access to sanitation facilities. Promoting gender equality in water management and sanitation is crucial for empowering women and achieving sustainable development goals.' ),
      CardData(title: 'Water and Industry', detail: 'Industrial activities contribute to water pollution and water scarcity challenges. Sustainable industrial practices, including water recycling and pollution prevention measures, are essential for reducing water footprint and preserving water resources.' ),
      CardData(title: 'Water and Health', detail: 'Access to clean water and sanitation is fundamental to human health and well-being. Improving water quality and sanitation facilities can prevent waterborne diseases and improve public health outcomes globally.' ),
      CardData(title: 'Water and Ecosystems', detail: 'Water ecosystems, including rivers, lakes, and wetlands, provide essential services such as water purification, flood regulation, and habitat for biodiversity. Protecting water ecosystems is crucial for maintaining ecological balance and sustainable development.' ),
    ];


  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
          ),
          title: Text(
            'Logout of WaterCactus?',
            style: CustomTextStyle.poppins1
          ),
          content: Text(
            'You can always log back in at any time',
            style: CustomTextStyle.poppins4.copyWith(color: AppColors.black)
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      // primary: Colors.black,
                    ),
                    child: Text(
                      'Cancel',
                      style: CustomTextStyle.poppins4.copyWith(color: AppColors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 17, 0),
                    ),
                    child: Text(
                      'Logout',
                      style: CustomTextStyle.poppins4.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushNamed(
                          context, '/login'); // Navigate to the login page
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                height: 100,
                width: 100,
                child: ClipOval(
                  child: Image.asset(
                      'assets/profile_page/dog.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Steve Hazard', style: CustomTextStyle.poppins6.copyWith(fontSize: 24)),
                      Text('steve@gmail.com', style: CustomTextStyle.poppins2),
                    ]
                  ),
                ),
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.edit_square, color: AppColors.black, size: 25),
                )
              ],
            ),
          ),
          SizedBox(height: 5),
          CardCarousel(cards: cardList),
          Padding(
            padding:  EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/unit');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: ClipOval(
                          child: Image.asset(
                              'assets/profile_page/measure.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      Text('Measurement unit', style: CustomTextStyle.poppins6),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/goal');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: ClipOval(
                          child: Image.asset(
                              'assets/profile_page/goal.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      Text('Custom goal', style: CustomTextStyle.poppins6),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/noti');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: ClipOval(
                          child: Image.asset(
                              'assets/profile_page/noti.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      Text('Notification setting', style: CustomTextStyle.poppins6),
                    ],
                  ),
                )
              ],
            )
          ),
          SizedBox(height: 10),
          Padding(
            padding:  EdgeInsets.all(20),
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My account', style: CustomTextStyle.poppins4),
                      SizedBox(height: 15),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: AppColors.darkGrey,                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => _showLogoutConfirmationDialog(),
                        child: Text('Log Out', style: CustomTextStyle.poppins6.copyWith(color: Colors.red, fontSize: 16))
                      ),
                    ],
                  ),
                ]
              ),
            )
          )
        ],
      ),
    );
  }
}
