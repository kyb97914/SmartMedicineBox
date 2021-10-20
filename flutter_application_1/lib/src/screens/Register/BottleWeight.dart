import 'package:Smart_Medicine_Box/src/screens/Main/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Medicine.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/appbar.dart';
import '../Components/RoundedButton.dart';

class BottleWeight extends StatefulWidget {
  BottleWeight({Key key}) : super(key: key);
  @override
  _BottleWeighteState createState() => _BottleWeighteState();
}

class _BottleWeighteState extends State<BottleWeight> {
  Future<String> patchWeight() async {
    print('patch');
    String usertoken = await UserSecureStorage.getUserToken();
    String bottleid = await UserSecureStorage.getBottleId();
    http.Response response = await http.patch(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/weight/' + bottleid),
      headers: {"Content-Type": "application/json", "authorization": usertoken},
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

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          appBar: appbar(context),
          body: Center(
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.9,
              
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Text(
                    '약병 무게 측정',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      '약병에 약을 둔 상태로 측정 버튼을 눌러 주세요',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RoundedButton(
                    text: "측정",
                    color: Colors.blue.shade600,
                    press: () {
                      print('asdf');
                      showDialog(
                          context: context,
                                  builder: (BuildContext context) {
                                        return AlertDialog(
                        title: new Text('약병 등록'),
                        content: FutureBuilder(
                          future: patchWeight(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
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
                              return Text('측정 완료');
                            }
                          },
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('Close'),
                            onPressed: () { Navigator.of(context).pop();},
                          ),
                        ],
                      );
                                  }
                      );
                    
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
