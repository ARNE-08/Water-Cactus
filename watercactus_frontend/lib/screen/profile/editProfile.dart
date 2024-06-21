import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage();

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List<String> profileImages = [
    'assets/profile_page/dog.jpg',
    'assets/profile_page/dog.jpg',
    'assets/profile_page/dog.jpg',
    'assets/profile_page/dog.jpg',
    'assets/profile_page/dog.jpg',
    'assets/profile_page/dog.jpg',
    'assets/profile_page/dog.jpg',
  ];

  Widget buildProfileImages(List<String> profileImages) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        key: const PageStorageKey('profileImages'),
        scrollDirection: Axis.horizontal,
        itemCount: profileImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0), // Adjust padding as needed
            child: GestureDetector(
              onTap: () {
                // Add your logic here
              },
              child: SizedBox(
                height: 65,
                width: 65,
                child: ClipOval(
                  child: Image.asset(
                    profileImages[
                        index], // Use the image URL or path from the list
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

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile_page/dog.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Steve Hazard',
                    style: CustomTextStyle.poppins6.copyWith(fontSize: 24)),
                const SizedBox(height: 5),
                Text('steve@gmail.com', style: CustomTextStyle.poppins2),
              ],
            ),
            const SizedBox(height: 30),
            Row(children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile image', style: CustomTextStyle.poppins4),
                      const SizedBox(height: 10),
                      buildProfileImages(profileImages),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text('Username', style: CustomTextStyle.poppins4),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Steve Hazard',
                                hintStyle: CustomTextStyle.poppins6
                                    .copyWith(color: AppColors.grey),
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.white),
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                            const SizedBox(height: 20),
                            Text('Email address',
                                style: CustomTextStyle.poppins4),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'steve@gmail.com',
                                hintStyle: CustomTextStyle.poppins6
                                    .copyWith(color: AppColors.grey),
                                prefixIcon:
                                    const Icon(Icons.mail, color: Colors.white),
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                            const SizedBox(height: 20),
                            Text('Password', style: CustomTextStyle.poppins4),
                            const SizedBox(height: 10),
                            TextField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'password',
                                hintStyle: CustomTextStyle.poppins6
                                    .copyWith(color: AppColors.grey),
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
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
                    ]),
              ),
            ]),
            SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(AppColors
                    .brightBlue), // Default to grey if beverageColor is null
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
