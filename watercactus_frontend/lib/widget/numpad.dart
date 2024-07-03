import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NumberPad extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  NumberPad({required this.buttonText, required this.buttonColor});

  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String _number = "0";
  String _unit = "ml";
  String? token;

  @override
  void initState() {
    super.initState();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    _getUnit(token);
  }

  Future<void> _getUnit(String? token) async {
    final String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

    final response = await http.get(
      Uri.parse('$apiUrl/getUnit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['data']);
      setState(() {
        _unit = jsonResponse['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch unit')),
      );
    }
  }

  void _addNumber(int value) {
    if (_number == "0") {
      _number = "";
    }
    setState(() {
      _number += value.toString();
    });
  }

  void _deleteNumber() {
    setState(() {
      if (_number.isNotEmpty) {
        _number = _number.substring(0, _number.length - 1);
      }
    });
  }

  void _submit() {
    Navigator.pop(context, _number);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_number $_unit',
            style: CustomTextStyle.poppins1,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            //! Custom text in each page
            child: Text('+ ${widget.buttonText.toUpperCase()}'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(widget.buttonColor),

            )
          ),
          SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 60.0, top: 0, right: 60, bottom: 0),
            children: List.generate(9, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    // color: AppColors.blue,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.lightGrey),
                      ),
                      onPressed: () {
                        _addNumber(index + 1);
                      },
                      child: Text(
                        '${index + 1}',
                        style: CustomTextStyle.poppins1
                            .copyWith(color: AppColors.white, fontSize: 20.0),
                      ),
                    ),
                  );
                }) +
                [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.lightGrey),
                      ),
                      onPressed: () {
                        _addNumber(0);
                      },
                      child: Text(
                        '0',
                        style: CustomTextStyle.poppins1
                            .copyWith(color: AppColors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                      ),
                      onPressed: _deleteNumber,
                      child: Icon(
                        Icons.backspace,
                        color: AppColors.darkGrey,
                        size: 30,
                      ),
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
