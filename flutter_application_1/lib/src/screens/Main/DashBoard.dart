import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../../utils/user_secure_stoarge.dart';
import '../../models/Bottle.dart';
import 'package:Smart_Medicine_Box/src/screens/Main/SettingPage.dart';
import 'BottleList.dart';
import 'MainPage.dart';
import 'FeedBack.dart';

class DashBoard extends StatefulWidget {
  int pageNumber;

  DashBoard({
    Key key,
    this.pageNumber,
  }) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;

  Widget build(BuildContext context) {
    _selectedIndex = widget.pageNumber;
    var _tabs = [
      ineerInformationpage(context),
      MainPage(),
      FeedbackPage(),
    ];

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color(0xffe5f4ff),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SettingPage(),
                    ));
              },
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
            ],
          ),
        ),
        body: _tabs[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
          child: const Icon(Icons.refresh_outlined),
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _selectedIndex,
          onTap: (int index) => {
            setState(() {
              _onItemTapped(index);
            })
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.device_thermostat), label: 'In'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              label: 'Feedback',
              icon: Icon(Icons.feedback),
            )
          ],
        ),
      ),
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BottleList(),
            ));
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.pageNumber = index;
    });
  }
}

Widget ineerInformationpage(BuildContext context) {
  //get bottle
  Future<Bottle> _getbottle() async {
    String usertoken = await UserSecureStorage.getUserToken();
    String bottleid = await UserSecureStorage.getBottleId();
    Bottle _bottleinformation = new Bottle();
    http.Response response = await http.get(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/' + bottleid),
        headers: {"authorization": usertoken});

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      _bottleinformation = Bottle.fromJson(jsonData);
    }
    return _bottleinformation;
  }

  final Size size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: Colors.white,
    body: FutureBuilder(
      future: _getbottle(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        } else {
          return Container(
            height: size.height * 0.9,
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  height: size.height * 0.08,
                  width: size.width,
                  child: Center(
                    child: Text(
                      'Inside Information',
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
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: size.height * 0.25,
                  width: size.width,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.43,
                              height: size.width * 0.45,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              decoration: BoxDecoration(
                                color: Color(0xff8E97FD),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.05,
                                    child: Center(
                                      child: Text(
                                        '약병 내부 온도',
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'NotoSansKR',
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.145,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${snapshot.data.temperature}' ==
                                                    null
                                                ? '-'
                                                : '${snapshot.data.temperature}',
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 50,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '℃',
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 50,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w800),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: size.width * 0.43,
                              height: size.width * 0.45,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              decoration: BoxDecoration(
                                color: Color(0xff8E97FD),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.05,
                                    child: Center(
                                      child: Text(
                                        '약병 내부 습도',
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'NotoSansKR',
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.14,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data.humidity.toString() ==
                                                    null
                                                ? '-'
                                                : snapshot.data.humidity
                                                    .toString(),
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 50,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '%',
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 50,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w800),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: size.height * 0.3,
                  width: size.width,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.43,
                              height: size.width * 0.45,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              decoration: BoxDecoration(
                                color: Color(0xff8E97FD),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.05,
                                    child: Center(
                                      child: Text(
                                        '약병 내부 잔량',
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'NotoSansKR',
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.14,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data.balance.toString() ==
                                                    null
                                                ? '-'
                                                : snapshot.data.balance
                                                    .toString(),
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 80,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            '%',
                                            textAlign: TextAlign.center,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 60,
                                                fontFamily: 'NotoSansKR',
                                                fontWeight: FontWeight.w800),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: size.width * 0.43,
                              height: size.width * 0.45,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              decoration: BoxDecoration(
                                color: Color(0xff8E97FD),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.05,
                                    child: Center(
                                      child: Text(
                                        '최근 개폐 시간',
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'NotoSansKR',
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    height: size.height * 0.14,
                                    child: Center(
                                      child: Text(
                                        snapshot.data.recentOpen == null
                                            ? '-'
                                            : DateFormat.Hm().format(
                                                snapshot.data.recentOpen),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontFamily: 'NotoSansKR',
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}
