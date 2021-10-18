import 'package:Smart_Medicine_Box/src/screens/Register/BottleWeight.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/user_secure_stoarge.dart';

import '../../models/Medicine.dart';

import '../Register/SearchMedicine.dart';
import '../../models/BottleInfo.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _seletedDoctor = '';
  Widget build(BuildContext context) {
    BottleInfo _bottleinfo;
    String _bottleId;

    //get bottle medicine
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

    //약병 무게 설정
    Future<String> patchWeight() async {
      String usertoken = await UserSecureStorage.getUserToken();
      String bottleid = await UserSecureStorage.getBottleId();
      http.Response response = await http.patch(
        Uri.encodeFull(
            DotEnv().env['SERVER_URL'] + 'bottle/weight/' + bottleid),
        headers: {
          "Content-Type": "application/json",
          "authorization": usertoken
        },
      );

      if (response.statusCode == 200) {
        return "Complete";
      } else if (response.statusCode == 404) {
        return "약병이 존재하지 않습니다.";
      } else if (response.statusCode == 403) {
        return "약병에 접근할 권한이 없습니다.";
      } else {
        return "알 수 없는 오류";
      }
    }

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder(
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
            } else if (snapshot.data == null)
              return Text('Loading');
            else if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else {
              return Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(
                                25.0) //         <--- border radius here
                            ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            child: Center(
                              child: Text(
                                  _bottleinfo.medeicine.name == null
                                      ? '-'
                                      : _bottleinfo.medeicine.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: size.width,
                            alignment: Alignment(0.9, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '처방의: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  _bottleinfo.doctorInfo.doctorNm == null
                                      ? '-'
                                      : _bottleinfo.doctorInfo.doctorNm,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: size.width,
                            alignment: Alignment(0.9, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '제조사: ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _bottleinfo.medeicine.company == null
                                      ? '-'
                                      : _bottleinfo.medeicine.company,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment(-1, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '타겟 층 : ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _bottleinfo.medeicine.target == null
                                      ? '-'
                                      : _bottleinfo.medeicine.target,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment(-1, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '복약 정보 : ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _bottleinfo.medeicine.dosage == null
                                      ? '-'
                                      : _bottleinfo.medeicine.dosage,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            alignment: Alignment(-1, 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  width: size.width,
                                  child: Text(
                                    '경고',
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 14),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  width: size.width,
                                  child: Text(
                                    _bottleinfo.medeicine.warn == null
                                        ? '-'
                                        : _bottleinfo.medeicine.warn,
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.8,
                        height: 46,
                        margin: EdgeInsets.only(bottom: 0),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          onPressed: () async {
                            String bottleid =
                                await UserSecureStorage.getBottleId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchMedicine(
                                  bottleId: bottleid,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '약 검색',
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
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.8,
                        height: 46,
                        margin: EdgeInsets.only(bottom: 0),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BottleWeight(),
                              ),
                            );
                          },
                          child: Text(
                            '약병 무게 등록',
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
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
