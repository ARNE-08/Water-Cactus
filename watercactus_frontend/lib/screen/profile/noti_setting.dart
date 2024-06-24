import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotiSettingPage extends StatefulWidget {
  const NotiSettingPage();

  @override
  State<StatefulWidget> createState() => _NotiSettingPageState();
}

class _NotiSettingPageState extends State<NotiSettingPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? token;
  final String? apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  List<dynamic> reminderTime = [];
  int list_length = 0;

  @override
  void initState() {
    super.initState();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    // print('token from noti page: $token');
    fetchReminder();
  }

  void fetchReminder() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/getReminder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        print('Succeed to fetch reminder: ${response.statusCode}');
        final Map<String, dynamic> fetchedReminderData = json.decode(response.body);
        // print('fetched reminder data: $fetchedReminderData');
        setState(() {
          reminderTime = (fetchedReminderData['data'] as List).map((item) {
            final timeParts = item['reminder_time'].split(':');
            final timeOfDay = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
            return {
              'id': item['id'],
              'user_id': item['user_id'],
              'reminder_time': timeOfDay,
              'enable': item['enable'] == 'on',
            };
          }).toList();
          list_length = reminderTime.length;
          // print('reminderTime: $reminderTime');
        });
      } else {
        print('Failed to fetch reminderTime: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching reminderTime: $error');
    }
  }

  void updateReminder(int index, String reminder_time, String enable) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/updateReminder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'index': index,
          'reminder_time': reminder_time,
          'enable': enable,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        // print('update notification: ${fetchedData['data']}');
      } else {
        print('Failed to update notification: ${response.statusCode}');
      }
    } catch (error) {
      print('Error update notification data: $error');
    }
  }

  Future<void> _showTimePicker(BuildContext context, int index) async {
    final TimeOfDay initialTime = reminderTime[index]['reminder_time'];
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        reminderTime[index]['reminder_time'] = picked;
        updateReminder(index + 1, reminderTime[index]['reminder_time'].format(context), reminderTime[index]['enable'] ? 'on' : 'off');
        fetchReminder();
      });
      // print('Here the updated existing reminder time: ');
      // print(reminderTime[index]['reminder_time'].format(context));
      // print(reminderTime[index]['enable']);
    }
  }

  Future<void> _showAddNewTimePicker(BuildContext context, int list_length) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        reminderTime.add({'reminder_time': picked, 'enable': true});
        list_length = reminderTime.length;
        updateReminder(list_length, reminderTime[list_length - 1]['reminder_time'].format(context), reminderTime[list_length - 1]['enable'] ? 'on' : 'off');
        fetchReminder();
      });
      // print('Here the updated existing reminder time: ');
      // print(reminderTime[list_length - 1]['reminder_time'].format(context));
      // print(reminderTime[list_length - 1]['enable']);
    }
  }

  Widget buildReminder(List<dynamic> reminderTime) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reminderTime.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _showTimePicker(context, index),
                    child: Text(
                      reminderTime[index]['reminder_time'].format(context),
                      style: CustomTextStyle.poppins4.copyWith(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Switch(
                    value: reminderTime[index]['enable'],
                    onChanged: (value) {
                      setState(() {
                        reminderTime[index]['enable'] = value;
                        // print(reminderTime[index]['enable']);
                        updateReminder(index + 1, reminderTime[index]['reminder_time'].format(context), reminderTime[index]['enable'] ? 'on' : 'off');
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reminder', style: CustomTextStyle.poppins6.copyWith(fontSize: 24)),
                          Switch(
                            value: false,
                            onChanged: (value) {
                              // Placeholder for onChanged logic
                            },
                            activeTrackColor: Colors.lightBlueAccent,
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('Time of each notification', style: CustomTextStyle.poppins4.copyWith(color: Colors.black)),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: AppColors.darkGrey,
                  ),
                  SizedBox(height: 20),
                  buildReminder(reminderTime),
                  SizedBox(height: 150), // Give space for the button
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
             color: AppColors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.only(left: 120, right: 120, bottom: 60, top: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(AppColors.tea),
                  ),
                  onPressed: () {
                    _showAddNewTimePicker(context, list_length);
                  },
                  child: Text('ADD NEW'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
