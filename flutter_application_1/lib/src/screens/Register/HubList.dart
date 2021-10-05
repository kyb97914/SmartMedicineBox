import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Screen import
import '../../models/Bottle.dart';
import 'RegisterBottle.dart';
import '../Main/BottleList.dart';
import '../../utils/user_secure_stoarge.dart';

class HubList extends StatefulWidget {
  List<int> hublist;
  HubList({Key key, this.hublist}) : super(key: key);

  @override
  _HubListState createState() => _HubListState();
}

class _HubListState extends State<HubList> {
  List<Bottle> _bottleList = new List<Bottle>();
  List<int> _hublist = new List<int>();
  //Get BottleList
  Future<String> getBottleList(int hubid) async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(
          DotEnv().env['SERVER_URL'] + 'bottle/hub/' + hubid.toString()),
      headers: {"authorization": usertoken},
    );

    if (_bottleList.length != 0) {
      _bottleList.clear();
    }
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);

      for (int i = 0; i < values.length; i++) {
        Map<String, dynamic> map = values[i];
        _bottleList.add(Bottle.fromJson(map));
        return "GET";
      }
    } else if (response.statusCode == 404) {
      return "Not Found";
    } else {
      return "Error";
    }
    return "Error";
  }

  Future<String> getHubList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub'),
      headers: {"authorization": usertoken},
    );
    print(response.body);
    List<dynamic> values = new List<dynamic>();
    if (_hublist.length != 0) {
      _hublist.clear();
    }
    print(response.statusCode);
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

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
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
              print('data:' + snapshot.data);
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
                          '등록된 허브 리스트',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(border: Border.all()),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(30),
                        itemCount: _hublist.length,
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
                                'HUB ID: ' + '${_hublist[index]}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Noto',
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () async {
                                //허브 id로 가져와서 있으면 바로 넘기기
                                var result =
                                    await getBottleList(_hublist[index]);
                                print(result);
                                if (result == "GET") {
                                  UserSecureStorage.setHubId(
                                      _hublist[index].toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BottleList(),
                                    ),
                                  );
                                } else if (result == "Not Found") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text('Error'),
                                        content: new Text('등록된 약병이 없습니다.'),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('등록'),
                                            onPressed: () {
                                              UserSecureStorage.setHubId(
                                                  _hublist[index].toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          RegisterBottle(),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
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
      ),
      onWillPop: () {
        SystemNavigator.pop();
      },
    );
  }
}
