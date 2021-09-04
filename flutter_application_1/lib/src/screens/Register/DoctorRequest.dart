import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/user_secure_stoarge.dart';

class DoctorRequest extends StatefulWidget {
  @override
  _DoctorRequestState createState() => _DoctorRequestState();
}

class _DoctorRequestState extends State<DoctorRequest> {
  List<int> _doctorlist = new List<int>();

  Future<String> getDoctorRequestList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub'),
      headers: {"authorization": usertoken},
    );
    List<dynamic> values = new List<dynamic>();
    if (_doctorlist.length != 0) {
      _doctorlist.clear();
    }
    if (response.statusCode == 200) {
      values = json.decode(response.body);
      for (int i = 0; i < values.length; i++) {
        _doctorlist.add(values[i]['hubId']);
      }
      return "get완료";
    } else if (response.statusCode == 404) {
      return "Not Found";
    } else {
      return "Error";
    }
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new Icon(Icons.medical_services_rounded,
            color: Colors.black, size: 45.0),
        title: Text(
          'Smart Medicine Box',
          style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'Noto',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: getDoctorRequestList(),
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
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: size.height * 0.1,
                    width: size.width,
                    child: Center(
                      child: Text(
                        '담당의 등록 요청',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Noto',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration:
                        BoxDecoration(border: Border.all(), color: Colors.blue),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(30),
                      itemCount: _doctorlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: ListTile(
                            title: Text(
                              'DoctorID: ' + '${_doctorlist[index]}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.check),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('담당의 등록'),
                                    content: new Text('담당의  등록이 완료 되었습니다.'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext contetx, int index) =>
                          const Divider(),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
