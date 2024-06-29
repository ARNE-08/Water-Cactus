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


int _successCount = 0; // Counter to track successful updates
bool _failedDialogShown = false;

Future<void> _updateProfilePicture() async {
  String? token = await getToken();
  String currentPassword = _oldPasswordController.text.trim(); // Assuming you have a controller for old password

  if (token != null && currentPassword.isNotEmpty && _profilePictureUrl != null) {
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
            'current_password': currentPassword,
            'profile_picture_id': profilePictureId,
          }),
        );
        print('API Response Status Code: ${response.statusCode}');
        if (response.statusCode == 200) {
          _successCount++; // Increment success count
          print('Profile picture updated successfully');
        } else if (response.statusCode == 401) {
          _showFailedDialogIfNeeded(context, 'Current password is incorrect');
        } else {
          final jsonResponse = json.decode(response.body);
          _showFailedDialogIfNeeded(context, 'Failed to update profile picture: ${jsonResponse['message']}');
        }
      } catch (e) {
        _showFailedDialogIfNeeded(context, 'Error updating profile picture: $e');
      }
    } else {
      print("Profile picture ID not found for $_profilePictureUrl");
    }
  } else {
    print("No token found, current password is empty, or profile picture URL is not selected");
  }

  // Check if we should show success dialog
  _checkShowSuccessDialog();
}

Future<void> _updateEmail() async {
  String? token = await getToken();
  String currentPassword = _oldPasswordController.text.trim(); // Assuming you have a controller for old password
  String newEmail = _newEmailController.text.trim();

  // Check if new email is empty before proceeding
  if (token != null && currentPassword.isNotEmpty && newEmail.isNotEmpty) {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/updateEmail'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_email': newEmail,
        }),
      );

      print('API Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        _successCount++; // Increment success count
        print('Email updated successfully');
      } else if (response.statusCode == 401) {
        _showFailedDialogIfNeeded(context, 'Current password is incorrect');
      } else {
        _showFailedDialogIfNeeded(context, 'Failed to update email: ${response.statusCode}');
      }
    } catch (e) {
      _showFailedDialogIfNeeded(context, 'Error updating email: $e');
    }
  } else {
    print('No token found, current password is empty, or new email is empty');
  }

  // Check if we should show success dialog
  _checkShowSuccessDialog();
}

Future<void> _updatePassword() async {
  String? token = await getToken();
  String currentPassword = _oldPasswordController.text.trim();
  String newPassword = _newPasswordController.text.trim();

  // Check if new password is empty before proceeding
  if (token != null && currentPassword.isNotEmpty && newPassword.isNotEmpty) {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/updatePassword'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      print('API Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        _successCount++; // Increment success count
        print('Password updated successfully');
      } else if (response.statusCode == 401) {
        _showFailedDialogIfNeeded(context, 'Current password is incorrect');
      } else {
        final jsonResponse = json.decode(response.body);
        _showFailedDialogIfNeeded(context, 'Failed to update password: ${jsonResponse['message']}');
      }
    } catch (e) {
      _showFailedDialogIfNeeded(context, 'Error updating password: $e');
    }
  } else {
    print('No token found, current password is empty, or new password is empty');
  }

  // Check if we should show success dialog
  _checkShowSuccessDialog();
}

void _checkShowSuccessDialog() {
  if (_successCount == 1) {
    _showSuccessDialog(context, 'Profile updated successfully');
  }
}

void _showFailedDialogIfNeeded(BuildContext context, String errorMessage) {
  if (!_failedDialogShown) {
    _failedDialogShown = true;
    _showFailedDialog(context, 'Failed', errorMessage);
  }
}

void _showFailedDialog(BuildContext context, String title, String errorMessage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: Colors.blue, // Change color as needed
                ),
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: Colors.blue, // Change color as needed
                ),
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/profile');
                },
              ),
            ],
          ),
        ),
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
                            ? (_profilePictureUrl!.startsWith('http')
                                ? Image.network(_profilePictureUrl!, fit: BoxFit.cover)
                                : Image.asset(_profilePictureUrl!, fit: BoxFit.cover))
                            : Image.asset(picture, fit: BoxFit.cover),
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
