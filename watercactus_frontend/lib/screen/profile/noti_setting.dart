import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watercactus_frontend/provider/token_provider.dart';
import 'package:watercactus_frontend/provider/switch_state.dart';
import 'package:watercactus_frontend/screen/home/home.dart';
import 'package:watercactus_frontend/theme/custom_theme.dart';
import 'package:watercactus_frontend/theme/color_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:watercactus_frontend/services/notification_service.dart';

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
  int listLength = 0;
  int maxNotiId = 0;
  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    notificationService.initialize();
    listenToNotificationStream();
    token = Provider.of<TokenProvider>(context, listen: false).token;
    // print('token from noti page: $token');
    fetchReminder();
  }

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
  });

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
        setState(() {
          reminderTime = (fetchedReminderData['data'] as List).map((item) {
            final timeParts = item['reminder_time'].split(':');
            final timeOfDay = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
            return {
              'id': item['id'],
              'user_id': item['user_id'],
              'reminder_time': timeOfDay,
              'enable': item['enable'] == 'on',
              'notification_id': item['notification_id'],
            };
          }).toList();
          listLength = reminderTime.length;
        });
      } else {
        print('Failed to fetch reminderTime: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching reminderTime: $error');
    }
  }

  Future<void> updateReminder(int index, String reminderTime, String enable, int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/updateReminder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'index': index,
          'reminder_time': reminderTime,
          'enable': enable,
          'notification_id': notificationId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('update notification in updateNotification(): ${fetchedData['data']}');
      } else {
        print('Failed to update notification: ${response.statusCode}');
      }
    } catch (error) {
      print('Error update notification data: $error');
    }
  }

  Future<void> addReminder(String reminderTime, int maxNotiId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/addReminder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'reminder_time': reminderTime,
          'noti_id': maxNotiId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('add notification in updateNotification(): ${fetchedData['data']}');
      } else {
        print('Failed to add notification: ${response.statusCode}');
      }
    } catch (error) {
      print('Error add notification data: $error');
    }
  }

  Future<void> deleteReminder(int index) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/deleteReminder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'index': index,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        print('delete notification in updateNotification(): ${fetchedData['data']}');
      } else {
        print('Failed to delete notification: ${response.statusCode}');
      }
    } catch (error) {
      print('Error delete notification data: $error');
    }
  }

  Future<void> fetchMaxNoti() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/getMaxNoti'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        print('Succeed to fetch max_noti_id: ${response.statusCode}');
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        List<dynamic> dataList = fetchedData['data'];

        setState(() {
          maxNotiId = dataList[0]['max_notification_id'];
        });
      } else {
        print('Failed to fetch max_noti_id: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching max_noti_id: $error');
    }
  }

  Future<void> toggleSwitch(bool value) async {
    Provider.of<SwitchState>(context, listen: false).toggleSwitch(value);
    if (!value) {
      notificationService.cancelAllNotifications();
    } else {
      fetchReminder();
      await fetchMaxNoti();

      for (int index = 0; index < reminderTime.length; index++) {
        if (reminderTime[index]['enable'] == 'on') {
          setState(() {
            updateReminder(
              index + 1,
              reminderTime[index]['reminder_time'].format(context),
              'on',
              maxNotiId + 1,
            );
          });

          notificationService.showScheduledDailyNotification(
            id: maxNotiId + 1,
            title: "Drink Water",
            body: "Time to drink some water!",
            time: reminderTime[index]['reminder_time'],
          );
          maxNotiId++;
        }
      }
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
      await fetchMaxNoti();
      setState(() {
        // print('This is the deleted noti_id: ${reminderTime[index]['notification_id']}');
        notificationService.cancelNotifications(reminderTime[index]['notification_id']);
        reminderTime[index]['reminder_time'] = picked;
        reminderTime[index]['enable'] = true;
      });
      await updateReminder(reminderTime[index]['id'], reminderTime[index]['reminder_time'].format(context), 'on', maxNotiId + 1);
        fetchReminder();
        buildReminder(reminderTime);
        // print('This is new added noti_id: ${maxNotiId + 1}');
        notificationService.showScheduledDailyNotification(
          id: maxNotiId + 1,
          title: "Drink Water",
          body: "Time to drink some water!",
          time: reminderTime[index]['reminder_time'],
        );
    }
  }

  Future<void> _showAddNewTimePicker(BuildContext context, int listLength) async {
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
      await fetchMaxNoti();
      print('max Noti id: $maxNotiId');
      setState(() {
        reminderTime.add({'reminder_time': picked, 'enable': true, 'notification_id': maxNotiId + 1});
        addReminder(picked.format(context), maxNotiId + 1);
        fetchReminder();
        buildReminder(reminderTime);
        listLength = reminderTime.length;
        notificationService.showScheduledDailyNotification(
          id: maxNotiId,
          title: "Drink Water",
          body: "Time to drink some water!",
          time: picked,
        );
      });
    }
  }

  Widget buildReminder(List<dynamic> reminderTime) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: reminderTime.length,
    itemBuilder: (context, index) {
      return Dismissible(
        key: Key(reminderTime[index]['notification_id'].toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          // Handle the deletion logic here
          final removedItem = reminderTime.removeAt(index);
          setState(() {
            notificationService.cancelNotifications(removedItem['notification_id']);
            deleteReminder(removedItem['id']);
            // fetchReminder(); // No need to call fetchReminder as we are directly manipulating the list
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reminder deleted')),
          );
        },
        background: Container(
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Container(
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
                      onChanged: (value) async {
                        await fetchMaxNoti();
                        setState(() {
                          reminderTime[index]['enable'] = value;
                          if (!value) {
                            notificationService.cancelNotifications(reminderTime[index]['notification_id']);
                            updateReminder(reminderTime[index]['id'], reminderTime[index]['reminder_time'].format(context), 'off', reminderTime[index]['notification_id']);
                          } else {
                            updateReminder(reminderTime[index]['id'], reminderTime[index]['reminder_time'].format(context), 'on', maxNotiId + 1);
                            fetchReminder();
                            notificationService.showScheduledDailyNotification(
                              id: maxNotiId + 1,
                              title: "Drink Water",
                              body: "Time to drink some water!",
                              time: reminderTime[index]['reminder_time'],
                            );
                          }
                        });
                      },
                      activeTrackColor: Colors.lightBlueAccent,
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),]
          ),
        ),
      );
    },
  );
}



  Widget buildPicture() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/noReminder.png'),
            SizedBox(height: 20),
            Text('No reminder set yet.', style: CustomTextStyle.poppins2),
            SizedBox(height: 5),
            Text('Please turn on Reminder.', style: CustomTextStyle.poppins2),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSwitched = Provider.of<SwitchState>(context).isSwitched;
    // print('isSwitched from noti page: $isSwitched');

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
                            value: isSwitched,
                            onChanged: toggleSwitch,
                            activeTrackColor: Colors.lightBlueAccent,
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  isSwitched
                      ? Column(
                          children: [
                            Text('Time of each notification', style: CustomTextStyle.poppins4.copyWith(color: Colors.black)),
                            SizedBox(height: 10),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: AppColors.darkGrey,
                            ),
                            SizedBox(height: 20),
                            isSwitched
                                ? buildReminder(reminderTime)
                                : buildPicture(),
                            SizedBox(height: 150), // Give space for the button
                          ],
                        )
                      : buildPicture(),
                ],
              ),
            ),
          ),
          if (isSwitched)
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
                      _showAddNewTimePicker(context, listLength);
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
