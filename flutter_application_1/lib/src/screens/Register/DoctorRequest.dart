import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/user_secure_stoarge.dart';
import '../../models/DoctorREQ.dart';

class DoctorRequest extends StatefulWidget {
  @override
  _DoctorRequestState createState() => _DoctorRequestState();
}

class _DoctorRequestState extends State<DoctorRequest> {
  List<DoctorREQ> _doctorlist = new List<DoctorREQ>();

  Future<String> getDoctorRequestList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    print(usertoken);
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'user/doctorrequest'),
      headers: {"authorization": usertoken},
    );
    print(response.statusCode);
    List<dynamic> values = new List<dynamic>();
    Map<String, dynamic> map = json.decode(response.body);
    values = map['doctorReqList'];
    print(values);
    if (_doctorlist.length != 0) {
      _doctorlist.clear();
    }
    if (response.statusCode == 200) {
      for (int i = 0; i < values.length; i++) {
        Map<String, dynamic> map = values[i];
        print('asdag');
        print(values[i]);
        _doctorlist.add(DoctorREQ.fromJson(map));
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
                              _doctorlist[index].doctorId,
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
