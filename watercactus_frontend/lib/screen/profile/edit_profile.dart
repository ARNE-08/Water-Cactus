import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage();

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future<String?> getToken() async {
    return Provider.of<TokenProvider>(context, listen: false).token;
  }

  @override
  void initState() {
    super.initState();
    _fetchProfilePicture();
  }

  // Future<void> _printToken() async {
  //   String? token = await getToken();
  //   if (token != null) {
  //     print("Token: $token");
  //   } else {
  //     print("No token found");
  //   }
  // }

  List<String> profileImages = [
    'assets/profile_page/dog.jpg',
  ];

  Map<String, int> presetToId = {};

  String? _profilePictureUrl;
  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  Future<void> _fetchProfilePicture() async {
    String? token = await getToken();
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$apiUrl/getProfilePicture'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        print('API Response Status Code: ${response.statusCode}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          //print('API Response Data: $data');
          List<dynamic> pictures = data['data'];
          setState(() {
            profileImages = pictures
                .map((picture) => picture['picture_preset'].toString())
                .toList();
            presetToId = {
              for (var picture in pictures)
                picture['picture_preset'].toString(): picture['profile_picture_id']
            };
          });
        } else {
          print('Failed to load profile pictures: ${response.statusCode}');
        }
      } catch (e) {
        print('Error loading profile pictures: $e');
      }
    } else {
      print("No token found");
    }
  }

  
  Future<void> _updateProfilePicture() async {
    String? token = await getToken();
    if (token != null && _profilePictureUrl != null) {
      int? profilePictureId = presetToId[_profilePictureUrl];
      if (profilePictureId != null) {
        try {
          final response = await http.put(
            Uri.parse('$apiUrl/updateProfilePicture'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'profile_picture_id': profilePictureId,
            }),
          );
          print('API Response Status Code: ${response.statusCode}');
          if (response.statusCode == 200) {
            print('Profile picture updated successfully');
            _showSuccessDialog(); // Show success popup
          } else {
            print('Failed to update profile picture: ${response.statusCode}');
            // Handle error, show error message, etc.
          }
        } catch (e) {
          print('Error updating profile picture: $e');
          // Handle error, show error message, etc.
        }
      } else {
        print("Profile picture ID not found");
      }
    } else {
      print("No token found or profile picture selected");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Profile picture updated successfully'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Widget buildProfileImages() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        key: const PageStorageKey('profileImages'),
        scrollDirection: Axis.horizontal,
        itemCount: profileImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _profilePictureUrl = profileImages[index];
                });
              },
              child: SizedBox(
                height: 65,
                width: 65,
                child: ClipOval(
                  child: Image.asset(
                    profileImages[index],
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: ClipOval(
                      child: _profilePictureUrl != null
                          ? Image.network(
                              _profilePictureUrl!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/profile_page/dog.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Steve Hazard',
                    style: CustomTextStyle.poppins6.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'steve@gmail.com',
                    style: CustomTextStyle.poppins2,
                  ),
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
                        Text('Profile image', style: CustomTextStyle.poppins4),
                        const SizedBox(height: 10),
                        buildProfileImages(),
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
                                  contentPadding:
                                      const EdgeInsets.only(left: 15),
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
                                  prefixIcon: const Icon(Icons.mail,
                                      color: Colors.white),
                                  contentPadding:
                                      const EdgeInsets.only(left: 15),
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
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.white),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 15),
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.brightBlue),
                ),
                onPressed: () {
                  _updateProfilePicture();
                 //_printToken();
                },
                child: Text('CONFIRM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
