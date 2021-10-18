import 'package:Smart_Medicine_Box/src/screens/SettingPage/HubModifyList.dart';
import 'package:flutter/material.dart';
import 'package:Smart_Medicine_Box/src/screens/Main/DashBoard.dart';
import 'package:Smart_Medicine_Box/src/screens/SettingPage/BottleModifyList.dart';
import 'package:Smart_Medicine_Box/src/screens/Components/appbar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:Smart_Medicine_Box/src/screens/Components/RoundedButton.dart';
import 'package:Smart_Medicine_Box/src/screens/SettingPage/InformationModify.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: appbar(context),
        body: Container(
          height: size.height * 0.9,
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                height: size.height * 0.08,
                width: size.width,
                child: Center(
                  child: Text(
                    'Setting',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RoundedButton(
                      text: "유저 정보 변경",
                      color: Colors.blue,
                      textColor: Colors.white,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                InformationModify(),
                          ),
                        );
                      },
                    ),
                    RoundedButton(
                      text: "허브 관리",
                      color: Colors.blue,
                      textColor: Colors.white,
                      press: () {},
                    ),
                    RoundedButton(
                      text: "약병 관리",
                      color: Colors.blue,
                      textColor: Colors.white,
                      press: () {},
                    ),
                    RoundedButton(
                      text: "로그 아웃",
                      color: Colors.blue,
                      textColor: Colors.white,
                      press: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          height: 50,
          backgroundColor: Colors.blue,
          items: <Widget>[
            Icon(Icons.history),
            Icon(Icons.home),
            Icon(Icons.feedback),
          ],
          onTap: (index) {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DashBoard(pageNumber: index),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
