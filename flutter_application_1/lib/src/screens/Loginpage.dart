import 'package:flutter/material.dart';
import 'dart:io';
import '../shared/colors.dart';
import './Register/SignInPage.dart';
import 'Register/SignUpLocal.dart';
import '../utils/PushManger.dart';
import '../utils/user_secure_stoarge.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

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
      print('token:' + token);
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
      body: GestureDetector(
        child: Container(
          color: Colors.white,
          height: size.height,
          child: Center(
              child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: size.height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'SMART MEDICINE BOX',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff004ca2),
                                fontSize: 30,
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Image.asset('images/main_logo.png',
                                width: 200, height: 250)),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: size.width * 0.8,
                          height: 46,
                          margin: EdgeInsets.only(bottom: 0),
                          child: FlatButton(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignInPage(),
                                ),
                              );
                            },
                            child: Text(
                              '로그인',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Color(0xff1674f6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          width: size.width * 0.8,
                          padding: EdgeInsets.all(0),
                          child: OutlineButton(
                            padding: EdgeInsets.fromLTRB(0, 25, 0, 15),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignUpLocal(),
                                ),
                              );
                            },
                            child: Text(
                              '회원 가입',
                              textScaleFactor: 1.0,
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Noto'),
                            ),
                            textColor: Colors.black,
                            highlightedBorderColor: highlightColor,
                            borderSide: BorderSide.none,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
      backgroundColor: bgColor,
    );
  }
}
