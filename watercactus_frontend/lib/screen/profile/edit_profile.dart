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
    _initialize();
  }

  List<String> profileImages = [
    'assets/profile_page/dog.jpg',
  ];

  Map<String, int> presetToId = {};
  String email = "user";
  String picture = "assets/Profile/user.jpg";

  String? _profilePictureUrl;
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  Future<void> _initialize() async {
    String? token = await getToken();
    if (token != null) {
      await _fetchProfilePicture(token);
      await _getEmail(token);
      _getPicture(token);
    } else {
      print("No token found");
    }
  }

  Future<void> _printToken() async {
    String? token = await getToken();
    if (token != null) {
      print("Token: $token");
    } else {
      print("No token found");
    }
  }

  Future<void> _fetchProfilePicture(String token) async {
    try {
       final response = await http.post(
        Uri.parse('$apiUrl/getProfilePicture'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'visible': 1,
        }),
      );
      print('API Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> pictures = data['data'];
        setState(() {
          profileImages = pictures
              .map((picture) => picture['picture_preset'].toString())
              .toList();
          presetToId = {
            for (var picture in pictures)
              picture['picture_preset'].toString():
                  picture['profile_picture_id']
          };
        });
      } else {
        print('Failed to load profile pictures: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading profile pictures: $e');
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
          }
        } catch (e) {
          print('Error updating profile picture: $e');
        }
      } else {
        print("Profile picture ID not found");
      }
    } else {
      print("No token found or profile picture selected");
    }
  }

  Future<void> _getEmail(String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/getEmail'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      //print(jsonResponse['data']);
      setState(() {
        email = jsonResponse['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch email')),
      );
    }
  }

  Future<void> _getPicture(String? token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/getUserProfile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      //print(jsonResponse['data']);
      setState(() {
        picture = jsonResponse['data']['picture_preset'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch email')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Profile updated successfully'),
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

  Future<void> _updateEmail() async {
    String? token = await getToken();

    if (token != null) {
      try {
        final response = await http.put(
          Uri.parse('$apiUrl/updateEmail'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'new_email': _newEmailController.text.trim(),
          }),
        );

        print('API Response Status Code: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('Email updated successfully');
          _showSuccessDialog(); // Show success popup
        } else {
          print('Failed to update email: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating email: $e');
      }
    } else {
      print('No token found');
    }
  }

  Future<void> _updatePassword() async {
    String? token = await getToken();

    if (token != null) {
      try {
        final response = await http.put(
          Uri.parse('$apiUrl/updatePassword'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'current_password': _oldPasswordController.text.trim(),
            'new_password': _newPasswordController.text.trim(),
          }),
        );

        print('API Response Status Code: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('Password updated successfully');
          _showSuccessDialog(); // Show success popup
        } else {
          final jsonResponse = json.decode(response.body);
          print('Failed to update password: ${response.statusCode}');
          print('Error message: ${jsonResponse['message']}');

          //print(_oldPasswordController.text.trim());
          //print(_newPasswordController.text.trim());
        }
      } catch (e) {
        print('Error updating password: $e');
      }
    } else {
      print('No token found');
    }
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
                              picture,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email.split('@')[0], // Extract username from email
                    style: CustomTextStyle.poppins6.copyWith(fontSize: 24),
                  ),
                  Text(email, style: CustomTextStyle.poppins2),
                  const SizedBox(height: 5),
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
                              Text('Email address',
                                  style: CustomTextStyle.poppins4),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _newEmailController,
                                decoration: InputDecoration(
                                  hintText: 'new email address',
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
                              Text('Current Password',
                                  style: CustomTextStyle.poppins4),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _oldPasswordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  hintText: 'current password',
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
                              const SizedBox(height: 20),
                              Text('New Password',
                                  style: CustomTextStyle.poppins4),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _newPasswordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                  hintText: 'new password',
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
                  _updateEmail();
                  _updatePassword();
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
