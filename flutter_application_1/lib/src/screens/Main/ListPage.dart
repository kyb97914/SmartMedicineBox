import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Screen import
import '../../models/Bottle.dart';
import '../Main/BottleList.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/RoundedButton.dart';
import '../Register/RegsiterHub.dart';
import '../../models/UserProfile.dart';
import '../Main/DashBoard.dart';

class ListPage extends StatefulWidget {
  List<int> hublist;
  ListPage({Key key, this.hublist}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Bottle> _bottleList = new List<Bottle>();
  List<int> _hublist = new List<int>();
  UserProfile userprofile;
  //Hub List의 Default index 0
  int hubIndex = 0;
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
      Map<String, dynamic> map = json.decode(response.body);
      values = map["bottleList"];

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
    Map<String, dynamic> map = json.decode(response.body);
    values = map["hubList"];
    if (response.statusCode == 200) {
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

  Future<String> getInfo() async {
    print('dasg');
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'user'),
      headers: {"authorization": usertoken},
    );
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    userprofile = UserProfile.fromJson(map['profile']);
    return "Get 완료";
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "SMART MEDICINE BOX",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Noto',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: size.height * 0.15,
                    width: size.width * 0.9,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: FutureBuilder(
                      future: getInfo(),
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
                          return Column(
                            children: <Widget>[
                              //d이부분은 나중에 꾸미자
                              Text(userprofile.userNm),
                              Text(userprofile.birth),
                              Text(userprofile.userId),
                              Text(userprofile.contact)
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _hublist.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildHub(index),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(30),
                      itemCount:
                          _bottleList.length == null ? 0 : _bottleList.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkResponse(
                          splashColor: Colors.transparent,
                          child: Container(
                            height: 140,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid),
                                    ),
                                  ),
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            '${_bottleList[index].bottleId}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Noto',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 70,
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                    size: 70,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            if (_bottleList[index].medicineId == null) {
                              //약병에 약이 없는 경우
                            } else {
                              UserSecureStorage.setBottleId(
                                  _bottleList[index].bottleId.toString());
                              UserSecureStorage.setMedicineId(
                                  _bottleList[index].medicineId.toString());
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => DashBoard(
                                  pageNumber: 0,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    height: size.height * 0.1,
                    child: RoundedButton(
                      text: "허브 추가",
                      press: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterHub(modify_hub: 0),
                          ),
                        );
                      },
                    ),
                  )
                ],
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

  Widget buildHub(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          hubIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 1.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _hublist[index].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: hubIndex == index
                        ? Colors.black
                        : Colors.grey.shade600),
              ),
              Container(
                height: 2,
                width: 30,
                color: hubIndex == index ? Colors.black : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegisterHub(modify_hub: 0),
                            ),
                          ); */
