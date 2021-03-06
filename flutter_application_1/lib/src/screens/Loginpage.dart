import 'package:flutter/material.dart';
import 'dart:io';
import './Register/SignInPage.dart';
import 'Register/SignUpLocal.dart';
import '../utils/PushManger.dart';
import '../utils/user_secure_stoarge.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'Components/background.dart';
import 'Components/RoundedButton.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
NotificationAppLaunchDetails notificationAppLaunchDetails;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

/// first page class
class _LoginPageState extends State<LoginPage> {
  var devicetoken = '';
  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    _localNotiSetting();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      UserSecureStorage.setDeviceToken(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(message);
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future _showNotification(message) async {
    String title, body;

    // AOS, iOS에 따라 message 오는 구조가 다르다. (직접 파베 찍어보면 확인 가능)
    if (Platform.isAndroid) {
      title = message['notification']['title'];
      body = message['notification']['body'];
      print('title' + title);
    }
    if (Platform.isIOS) {
      title = message['aps']['alert']['title'];
      body = message['aps']['alert']['body'];
    }

    // AOS, iOS 별로 notification 표시 설정
    var androidNotiDetails = AndroidNotificationDetails(
        'dexterous.com.flutter.local_notifications', title, body,
        importance: Importance.max, priority: Priority.max);
    var iOSNotiDetails = IOSNotificationDetails();

    var details =
        NotificationDetails(android: androidNotiDetails, iOS: iOSNotiDetails);

    await flutterLocalNotificationsPlugin.show(0, title, body, details);
    // 0은 notification id 값을 넣으면 된다.
  }

  void _localNotiSetting() async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // 안드로이드 알림 올 때 앱 아이콘 설정

    var iOSInitializationSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);
    // iOS 알림, 뱃지, 사운드 권한 셋팅
    // 만약에 사용자에게 앱 권한을 안 물어봤을 경우 이 셋팅으로 인해 permission check 함

    var initsetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initsetting);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Text(
                'SMART MEDICINE BOX',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Color(0xff004ca2),
                    fontSize: 30,
                    fontFamily: 'Noto',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.05),
              Image.asset('images/main_logo.png', width: 200, height: 250),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "로그인",
                color: Colors.blue.shade600,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignInPage(),
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "회원가입",
                color: Colors.blue.shade300,
                textColor: Colors.white,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignUpLocal(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
