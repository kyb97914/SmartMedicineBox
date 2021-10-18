import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Screen import
import '../../models/Bottle.dart';
import '../../models/Hub.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Register/RegsiterHub.dart';
import '../../models/UserProfile.dart';
import '../Main/DashBoard.dart';
import '../Register/DoctorRequest.dart';
import '../Components/appbar.dart';
import '../Register/RegisterBottle.dart';

import '../../models/BottleInfo.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Bottle> _bottleList = new List<Bottle>();
  List<Hub> _hublist = new List<Hub>();

  final hubNmController = TextEditingController();
  final bottleNmController = TextEditingController();
  String hubNm;
  UserProfile userprofile;
  //Doctor Request Alarm
  int newalarm = 0;
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
      }
      return "GET";
    } else if (response.statusCode == 404) {
      return "Not Found";
    } else {
      return "Error";
    }
  }

  //Get Hub List
  Future<String> getHubList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub'),
      headers: {"authorization": usertoken},
    );

    if (_hublist.length != 0) {
      _hublist.clear();
    }
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      Map<String, dynamic> map = json.decode(response.body);
      values = map["hubList"];
      for (int i = 0; i < values.length; i++) {
        Map<String, dynamic> map = values[i];
        _hublist.add(Hub.fromJson(map));
      }
      return "get완료";
    } else if (response.statusCode == 404) {
      return "Not Found";
    } else {
      return "Error";
    }
  }

  //Patch hub
  Future<String> patchHub(String hubid) async {
    String usertoken = await UserSecureStorage.getUserToken();

    http.Response response = await http.patch(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub/' + hubid),
      headers: {"Content-Type": "application/json", "authorization": usertoken},
      body: jsonEncode(
        {
          'hubNm': hubNmController.text,
        },
      ),
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

  Future<String> patchBottle(String bottleid) async {
    String usertoken = await UserSecureStorage.getUserToken();
    print(bottleid);
    http.Response response = await http.patch(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/name/' + bottleid),
      headers: {"Content-Type": "application/json", "authorization": usertoken},
      body: jsonEncode(
        {
          'bottleNm': bottleNmController.text,
        },
      ),
    );
    print(response.statusCode);
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

  //Get Info
  Future<String> getInfo() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'user'),
      headers: {"authorization": usertoken},
    );
    Map<String, dynamic> map = json.decode(response.body);
    userprofile = UserProfile.fromJson(map['profile']);
    return "Get 완료";
  }

  //Get bottle Medicine
  Future<String> getbottlemedicine(int bottleid) async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(
          DotEnv().env['SERVER_URL'] + 'bottle/' + bottleid.toString()),
      headers: {"authorization": usertoken},
    );
    if (response.statusCode == 200) {
      BottleInfo bottleinfo;
      Map<String, dynamic> map = json.decode(response.body);
      bottleinfo = BottleInfo.fromJson(map);
      return "get";
    } else {
      return "error";
    }
  }

  //Delete Hub
  Future<String> deleteHub(int index) async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.delete(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub/' + index.toString()),
      headers: {"authorization": usertoken},
    );
    if (response.statusCode == 204) {
      return "Delete";
    } else {
      return "Error";
    }
  }

  Future<String> deleteBottle(int index) async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.delete(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/' + index.toString()),
      headers: {"authorization": usertoken},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      return "Delete";
    } else {
      return "Error";
    }
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: appbar(context),
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
                    height: size.height * 0.01,
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
                          return Row(
                            children: <Widget>[
                              SizedBox(width: size.width * 0.05),
                              Icon(
                                Icons.account_circle_outlined,
                                size: 60,
                              ),
                              SizedBox(width: 15),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: userprofile.userNm + "\n",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: "  \n",
                                      style: TextStyle(
                                        fontSize: 3,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: userprofile.userId + "\n",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  \n",
                                      style: TextStyle(
                                        fontSize: 3,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: userprofile.contact,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                      itemCount: _hublist.length + 1,
                      itemBuilder: (BuildContext context, int index) =>
                          buildHub(index),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: getBottleList(_hublist[hubIndex].hubId),
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
                        return Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(30),
                            itemCount: _bottleList.length == null
                                ? 0
                                : _bottleList.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return InkResponse(
                                splashColor: Colors.transparent,
                                child: index == _bottleList.length
                                    ? GestureDetector(
                                        child: Container(
                                          height: 140,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16.0),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add_circle_outline_sharp,
                                            size: 70,
                                          ),
                                        ),
                                        onTap: () async {
                                          UserSecureStorage.setHubId(
                                              _hublist[hubIndex]
                                                  .hubId
                                                  .toString());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RegisterBottle(
                                                hubid: _hublist[hubIndex]
                                                    .hubId
                                                    .toString(),
                                                modify_bottle: false,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text(
                                                    _bottleList[index]
                                                        .bottleNm),
                                                content: Container(
                                                  height: 200,
                                                  width: 200,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        '약병 이름 변경',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 3),
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(29),
                                                          border: Border.all(),
                                                        ),
                                                        child: TextField(
                                                          controller:
                                                              bottleNmController,
                                                          onChanged: (text) {
                                                            hubNm = text;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "약병 이름을 입력하세요",
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child: new Text('이름 변경'),
                                                    onPressed: () async {
                                                      String saveMessage =
                                                          await patchBottle(
                                                              _bottleList[index]
                                                                  .bottleId
                                                                  .toString());
                                                      print(saveMessage);
                                                      if (saveMessage ==
                                                          "Complete") {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: new Text(
                                                                  '이름 변경 완료'),
                                                              content: new Text(
                                                                  '완료'),
                                                              actions: <Widget>[
                                                                new FlatButton(
                                                                    child: new Text(
                                                                        'Close'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (BuildContext context) =>
                                                                              ListPage(),
                                                                        ),
                                                                      );
                                                                    })
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  new FlatButton(
                                                    child: new Text('삭제'),
                                                    onPressed: () async {
                                                      await deleteBottle(
                                                          _bottleList[index]
                                                              .bottleId);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ListPage(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  new FlatButton(
                                                    child: new Text('닫기'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
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
                                                        style:
                                                            BorderStyle.solid),
                                                  ),
                                                ),
                                                height: 35,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      child: Center(
                                                        child: Text(
                                                          _bottleList[index]
                                                              .bottleNm,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'Noto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                  Icons
                                                      .medical_services_outlined,
                                                  size: 70,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                onTap: () async {
                                  UserSecureStorage.setBottleId(
                                      _bottleList[index].bottleId.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DashBoard(
                                        pageNumber: 1,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: Container(
          child: FittedBox(
            child: Stack(
              alignment: Alignment(1.4, -1.5),
              children: [
                FloatingActionButton(
                  onPressed: () {
                    //여기 누르면 넘어가는데 아마 숫자가 있을 경우만 넘어가도록 하기
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DoctorRequest(),
                      ),
                    );
                  },
                  child: Icon(Icons.email_outlined),
                  backgroundColor: Colors.blue,
                ),
                newalarm != 0
                    ? Container(
                        // This is your Badge
                        child: Center(
                          // child 문을  ? : 를 이용하여 구분하자
                          child: Text(newalarm.toString(),
                              style: TextStyle(color: Colors.white)),
                        ),
                        padding: EdgeInsets.all(8),
                        constraints:
                            BoxConstraints(minHeight: 32, minWidth: 32),
                        decoration: BoxDecoration(
                          // This controls the shadow
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 5,
                                color: Colors.black.withAlpha(50))
                          ],
                          borderRadius: BorderRadius.circular(16),
                          color:
                              Colors.blue, // This would be color of the Badge
                        ),
                      )
                    : new Container()
              ],
            ),
          ),
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
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(_hublist[index].hubNm),
              content: Container(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      Text(
                        '허브 이름 변경',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                          border: Border.all(),
                        ),
                        child: TextField(
                          controller: hubNmController,
                          onChanged: (text) {
                            hubNm = text;
                          },
                          decoration: InputDecoration(
                            hintText: "허브 이름을 입력하세요",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  )),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('이름 변경'),
                  onPressed: () async {
                    String saveMessage = await patchBottle(
                        _bottleList[index].bottleId.toString());
                    print(saveMessage);
                    if (saveMessage == "Complete") {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text('이름 변경 완료'),
                            content: new Text('완료'),
                            actions: <Widget>[
                              new FlatButton(
                                  child: new Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ListPage(),
                                      ),
                                    );
                                  })
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                new FlatButton(
                  child: new Text('삭제'),
                  onPressed: () async {
                    await deleteHub(_hublist[index].hubId);
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ListPage(),
                      ),
                    );
                  },
                ),
                new FlatButton(
                  child: new Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: index == _hublist.length
          ? IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.blue,
                size: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RegisterHub(modify_hub: 0),
                  ),
                );
              })
          : Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _hublist[index].hubNm,
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
                      color:
                          hubIndex == index ? Colors.black : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
