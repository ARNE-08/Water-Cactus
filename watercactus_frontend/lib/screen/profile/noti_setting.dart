import 'package:flutter/material.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';

class NotiSettingPage extends StatefulWidget {
  const NotiSettingPage();

  @override
  State<StatefulWidget> createState() => _NotiSettingPageState();
}

class _NotiSettingPageState extends State<NotiSettingPage> {
  List<Map<String, dynamic>> reminderTime = [
    {'time': TimeOfDay(hour: 8, minute: 0), 'enable': false},
    {'time': TimeOfDay(hour: 12, minute: 0), 'enable': false},
    {'time': TimeOfDay(hour: 16, minute: 0), 'enable': false},
    {'time': TimeOfDay(hour: 20, minute: 0), 'enable': false},
  ];

  Future<void> _showTimePicker(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: reminderTime[index]['time'],
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        reminderTime[index]['time'] = picked;
      });
      print(reminderTime[index]['time']);
      print(reminderTime[index]['enable']);
    }
  }

  Widget buildReminder(List<Map<String, dynamic>> reminderTime) {
    return Container(
      height: reminderTime.length * 100.0,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.builder(
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
                        reminderTime[index]['time'].format(context),
                        style: CustomTextStyle.poppins4.copyWith(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    Switch(
                      value: reminderTime[index]['enable'],
                      onChanged: (value) {
                        setState(() {
                          reminderTime[index]['enable'] = value;
                          print(reminderTime[index]['enable']);
                        });
                        // Add logic to update database or perform other actions based on `value`
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
      ),
    );
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
                        value: false, // Placeholder for a switch value
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
              Text('Time of each notification',
                  style: CustomTextStyle.poppins4.copyWith(color: Colors.black)),
              SizedBox(height: 10),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.5,
                color: AppColors.darkGrey,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  buildReminder(reminderTime)
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(140, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.tea),
                ),
                onPressed: () {
                  // Add your logic here
                },
                child: Text('ADD NEW'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
