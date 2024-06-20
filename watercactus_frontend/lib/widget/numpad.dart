import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';

class NumberPad extends StatefulWidget {
  final String buttonText;
  NumberPad({required this.buttonText});

  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String _number = "0";

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
            '$_number ml',
            style: CustomTextStyle.poppins1,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            //! Custom text in each page
            child: Text('+ ${widget.buttonText}'),
          ),
          SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(left: 60.0, top: 0, right: 60, bottom: 0),
            children: List.generate(9, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    // color: AppColors.blue,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightGrey),
                      ),
                      onPressed: () {
                        _addNumber(index + 1);
                      },
                      child: Text(
                        '${index + 1}',
                        style: CustomTextStyle.poppins1.copyWith(color: AppColors.white, fontSize: 20.0),
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
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightGrey),
                      ),
                      onPressed: () {
                        _addNumber(0);
                      },
                      child: Text(
                        '0',
                        style: CustomTextStyle.poppins1.copyWith(color: AppColors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      onPressed: _deleteNumber,
                      child: Icon(Icons.backspace, color: AppColors.darkGrey, size: 30,),
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
