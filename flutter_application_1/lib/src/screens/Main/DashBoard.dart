import 'package:Smart_Medicine_Box/src/screens/Main/ListPage.dart';
import 'package:Smart_Medicine_Box/src/screens/Register/SearchMedicine.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../../utils/user_secure_stoarge.dart';
import '../../models/BottleInfo.dart';
import 'package:Smart_Medicine_Box/src/screens/Main/SettingPage.dart';
import 'MainPage.dart';
import 'FeedBackPage.dart';
import '../Components/appbar.dart';
import '../Components/RoundedButton.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
    final Size size = MediaQuery.of(context).size;
    _selectedIndex = widget.pageNumber;
    var _tabs = [
      ineerInformationpage(context),
      MainPage(),
      FeedbackPage(),
    ];

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color(0xffe5f4ff),
        appBar: appbar(context),
        body: _tabs[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
          child: const Icon(Icons.refresh_outlined),
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: widget.pageNumber,
          height: 50,
          backgroundColor: Colors.blue,
          items: <Widget>[
            Icon(Icons.history),
            Icon(Icons.home),
            Icon(Icons.feedback)
          ],
          onTap: (index) {
            setState(() {
              _onItemTapped(index);
            });
          },
        ),
      ),
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ListPage(),
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
  BottleInfo _bottleinfo;
  String _bottleId;
  //get bottle

  Future<String> getbottlemedicine() async {
    String usertoken = await UserSecureStorage.getUserToken();
    String bottleid = await UserSecureStorage.getBottleId();
    _bottleId = bottleid;
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/' + bottleid),
      headers: {"authorization": usertoken},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      _bottleinfo = BottleInfo.fromJson(map);
      return "get";
    } else {
      return "error";
    }
  }

  final Size size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: Colors.white,
    body: FutureBuilder(
      future: getbottlemedicine(),
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
        } else if (snapshot.data == null) {
          return Text('Loading');
        } else if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
          if (_bottleinfo.medeicine == null) {
            //넘기는 페이지 작성
            return RoundedButton(
              text: "로그인",
              color: Colors.blue.shade600,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SearchMedicine(bottleId: _bottleId),
                  ),
                );
              },
            );
          } else if (_bottleinfo.takeMedicineHist.length == 0) {
            //뚜껑 여닫는거 없을 때
            return Container(
              height: size.height * 0.9,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                              '-',
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                              '-',
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                              '0',
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 80,
                                                  fontFamily: 'NotoSansKR',
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              '개',
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                          '00:00',
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
                  Container(
                    child: Text(
                      '약병 이용 기록이 없습니다.',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                              _bottleinfo.takeMedicineHist ==
                                                      null
                                                  ? '-'
                                                  : _bottleinfo
                                                          .takeMedicineHist[0]
                                                          .temperature
                                                          .toString() +
                                                      ' ℃',
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                  fontFamily: 'NotoSansKR',
                                                  fontWeight: FontWeight.w800),
                                            ),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                              _bottleinfo.takeMedicineHist ==
                                                      null
                                                  ? '-'
                                                  : _bottleinfo
                                                          .takeMedicineHist[0]
                                                          .humidity
                                                          .toString() +
                                                      '%',
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                  fontFamily: 'NotoSansKR',
                                                  fontWeight: FontWeight.w800),
                                            ),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                              _bottleinfo.takeMedicineHist ==
                                                      null
                                                  ? '-'
                                                  : _bottleinfo
                                                      .takeMedicineHist[0]
                                                      .dosage
                                                      .toString(),
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 60,
                                                  fontFamily: 'NotoSansKR',
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              '개',
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 55,
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                                        child: _bottleinfo.takeMedicineHist ==
                                                null
                                            ? Text('-',
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    color: Colors.white,
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight:
                                                        FontWeight.w800))
                                            : RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: _bottleinfo
                                                              .takeMedicineHist[
                                                                  0]
                                                              .takeDate
                                                              .month
                                                              .toString() +
                                                          '월 ' +
                                                          _bottleinfo
                                                              .takeMedicineHist[
                                                                  0]
                                                              .takeDate
                                                              .day
                                                              .toString() +
                                                          '일\n',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'NotoSansKR',
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    TextSpan(
                                                      text: _bottleinfo
                                                              .takeMedicineHist[
                                                                  0]
                                                              .takeDate
                                                              .hour
                                                              .toString() +
                                                          ':' +
                                                          _bottleinfo
                                                              .takeMedicineHist[
                                                                  0]
                                                              .takeDate
                                                              .minute
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 40,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'NotoSansKR',
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  ],
                                                ),
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
        }
      },
    ),
  );
}
