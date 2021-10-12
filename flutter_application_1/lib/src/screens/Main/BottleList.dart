import 'dart:convert';
import 'package:Smart_Medicine_Box/src/screens/Register/DoctorRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Bottle.dart';
import 'DashBoard.dart';
import '../../utils/user_secure_stoarge.dart';

class BottleList extends StatefulWidget {
  BottleList({Key key}) : super(key: key);

  @override
  _BottleListState createState() => _BottleListState();
}

class _BottleListState extends State<BottleList> {
  int newalarm = 0;

  String valueText;
  List<Bottle> _bottleList = new List<Bottle>();
  TextEditingController _textFieldController = TextEditingController();

  Future<String> getBottleList() async {
    String hubid = await UserSecureStorage.getHubId();
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
      values = map['bottleList'];
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
          future: getBottleList(),
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
                    SizedBox(height: 10),
                    Container(
                      height: size.height * 0.07,
                      width: size.width,
                      child: Center(
                        child: Text(
                          'BOTTLE LIST',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                              /*
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
                            */
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
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
}
