import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(60); // Adjust the height as needed
}

class _NavbarState extends State<Navbar> {
  final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String picture = "assets/Profile/user.jpg";
  String? token;

  @override
  void initState() {
    super.initState();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    _getPicture(token);
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
      print(jsonResponse['data']);
      setState(() {
        picture = jsonResponse['data']['picture_preset'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile picture')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: widget.preferredSize.height,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.equalizer, color: AppColors.black, size: 35),
                  onPressed: () {
                    Navigator.pushNamed(context, '/stat');
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: ClipOval(
                      child: Image.asset(
                        picture,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
