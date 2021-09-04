import 'package:Smart_Medicine_Box/src/screens/SettingPage/HubModifyList.dart';
import 'package:flutter/material.dart';
import 'package:Smart_Medicine_Box/src/screens/Main/DashBoard.dart';
import 'package:Smart_Medicine_Box/src/screens/SettingPage/BottleModifyList.dart';

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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Smart Medicine Box',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Noto',
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {},
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Test 1'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Test 2'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Test 3'),
                onTap: () {},
              ),
            ],
          ),
        ),
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
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      width: size.width * 0.8,
                      height: size.height * 0.13,
                      margin: EdgeInsets.only(bottom: 0),
                      child: FlatButton(
                        height: size.height * 0.07,
                        onPressed: () {},
                        child: Text(
                          '알림 설정',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xff0B1E33),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      width: size.width * 0.8,
                      height: size.height * 0.13,
                      margin: EdgeInsets.only(bottom: 0),
                      child: FlatButton(
                        height: size.height * 0.07,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HubModifyList(),
                              ));
                        },
                        child: Text(
                          '허브 관리',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xff0B1E33),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      width: size.width * 0.8,
                      height: size.height * 0.13,
                      margin: EdgeInsets.only(bottom: 0),
                      child: FlatButton(
                        height: size.height * 0.07,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BottleModifyList(),
                              ));
                        },
                        child: Text(
                          '약병 관리',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xff0B1E33),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.white.withOpacity(.60),
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: 0,
          onTap: (int index) => {
            setState(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DashBoard(pageNumber: index),
                  ),
                );
              },
            )
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.device_thermostat), label: 'In'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              label: 'Out',
              icon: Icon(Icons.access_time),
            )
          ],
        ),
      ),
    );
  }
}
