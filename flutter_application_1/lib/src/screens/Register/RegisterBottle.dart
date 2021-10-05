import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'SearchMedicine.dart';
import '../Main/BottleList.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/RoundedButton.dart';
import '../Components/background.dart';
import 'package:flutter_svg/svg.dart';

class RegisterBottle extends StatefulWidget {
  final String hubid;
  final bool modify_bottle;
  RegisterBottle({Key key, this.hubid, this.modify_bottle}) : super(key: key);
  @override
  _RegisterBottleState createState() => _RegisterBottleState();
}

class _RegisterBottleState extends State<RegisterBottle> {
  final medicineBottleIDController = TextEditingController();

  Future<String> registerbottle_Validate() async {
    String usertoken = await UserSecureStorage.getUserToken();
    String hubid = await UserSecureStorage.getHubId();

    http.Response bottleresponse = await http.post(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle'),
        headers: {
          "Content-Type": "application/json",
          "authorization": usertoken
        },
        body: jsonEncode(
            {'bottleId': medicineBottleIDController.text, 'hubId': hubid}));

    if (bottleresponse.statusCode == 201) {
      return "등록 완료";
    } else if (bottleresponse.statusCode == 404) {
      return "Hub 없음";
    } else if (bottleresponse.statusCode == 403) {
      return "유저 정보 없음 ";
    } else if (bottleresponse.statusCode == 404) {
      return "HOST 없음";
    } else {
      return "오류";
    }
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // int goals = 60;
    // int points = 75;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Background(
          child: ListView(
            padding: const EdgeInsets.all(40),
            children: <Widget>[
              SizedBox(
                height: size.height * 0.05,
              ),
              Center(
                child: Text(
                  "약병 등록",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SvgPicture.asset(
                "images/registerhub.svg",
                height: size.height * 0.2,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(),
                ),
                child: TextField(
                  controller: medicineBottleIDController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.medical_services_sharp,
                      color: Colors.black,
                    ),
                    hintText: "약병 ID 입력",
                    border: InputBorder.none,
                  ),
                ),
              ),
              RoundedButton(
                text: "약병 등록",
                press: () async {
                  String saveMessage = await registerbottle_Validate();
                  if (saveMessage == "등록 완료" && widget.modify_bottle == false) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('약병 등록'),
                          content: new Text('약병 등록이 완료 되었습니다.'),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('Close'),
                              onPressed: () {
                                UserSecureStorage.setBottleId(
                                    medicineBottleIDController.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SearchMedicine(
                                      bottleId: medicineBottleIDController.text,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else if (saveMessage == "등록 완료" &&
                      widget.modify_bottle == true) {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('약병 등록'),
                          content: new Text('약병 등록이 완료 되었습니다.'),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('오류'),
                          content: new Text(saveMessage),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
