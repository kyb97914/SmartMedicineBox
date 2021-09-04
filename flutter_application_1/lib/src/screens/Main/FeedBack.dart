import 'package:flutter/material.dart';
import '../../utils/user_secure_stoarge.dart';

import '../../models/Medicine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Doctor.dart';
import '../../models/BottleMedicine.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  Widget build(BuildContext context) {
    Medicine _medicineInformation = new Medicine();

    List<Doctor> _doctorlist = new List<Doctor>();
    List<int> _hublist = new List<int>();

    Future<String> getHubList() async {
      String usertoken = await UserSecureStorage.getUserToken();
      http.Response response = await http.get(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub'),
        headers: {"authorization": usertoken},
      );
      List<dynamic> values = new List<dynamic>();
      if (_hublist.length != 0) {
        _hublist.clear();
      }
      if (response.statusCode == 200) {
        values = json.decode(response.body);
        for (int i = 0; i < values.length; i++) {
          _hublist.add(values[i]['hubId']);
        }
        return "get완료";
      } else if (response.statusCode == 404) {
        return "Not Found";
      } else {
        return "Error";
      }
    }

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getHubList(),
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
                      width: size.width * 0.81,
                      height: size.height * 0.1,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                    child: Text('권고',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Noto',
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                    child: Text('주의',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Noto',
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                    child: Text('경고',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Noto',
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: size.width * 0.2,
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                    child: Text('치명',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Noto',
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _hublist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: ListTile(
                              title: Text(
                                '담당의 :  ' + '${_hublist[index]}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Noto',
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                Icons.circle,
                                color: Colors.red,
                              ),
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text('피드백 내용'),
                                        content: new Text('대충 피드백 내용'),
                                        actions: <Widget>[
                                          new FlatButton(
                                              child: new Text('닫기'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              })
                                        ],
                                      );
                                    });
                              },
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext contetx, int index) =>
                            const Divider(),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
