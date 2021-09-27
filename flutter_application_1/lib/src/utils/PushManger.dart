import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import '../utils/user_secure_stoarge.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class PushManager {
  static final PushManager _manager = PushManager._internal();

  final _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin fltNotification;
  factory PushManager() {
    return _manager;
  }

  PushManager._internal() {
    // 초기화 코드
  }

  void initState() {
    main();
  }

  Future<void> main() async {
    // needed if you intend to initialize in the `main` function
    WidgetsFlutterBinding.ensureInitialized();
    // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
    // change the default route of the app
    // var notificationAppLaunchDetails =
    //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {});
    var initializationSettings = InitializationSettings();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  void _requestIOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void registerToken() {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    _firebaseMessaging.getToken().then((token) {
      print('devicetoken');
      print(token);
      UserSecureStorage.setDeviceToken(token);
      // 장고 서버에 token알려주기
    });
  }

  void listenFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // Triggered if a message is received whilst the app is in foreground
        _showNotification();
        _ddd();
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        // Triggered if a message is received whilst the app is in background
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        // Triggered if a message is received if the app was terminated
        print('on launch $message');
      },
    );
  }

  Future<void> _ddd() async {
    await print('adsf');
  }

  Future<void> _showNotification() async {
    print('adsgasdfagasdf');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}
