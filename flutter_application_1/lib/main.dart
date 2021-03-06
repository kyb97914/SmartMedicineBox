import 'package:Smart_Medicine_Box/src/utils/localNotification.dart';
import 'package:flutter/material.dart';
import './src/screens/Loginpage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/all.dart';

Future main() async {
  await DotEnv().load('.env');
  KakaoContext.clientId = "dc275755272983cddfdd0419a2c90305";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  localNotification.initLocalNotificationPlugin();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART MEDICINE BOX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
