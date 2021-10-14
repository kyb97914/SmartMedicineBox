import 'package:Smart_Medicine_Box/src/screens/SettingPage/HubModifyList.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'RegisterBottle.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/RoundedButton.dart';
import '../Components/background.dart';

class RegisterHub extends StatefulWidget {
  final int modify_hub;

  RegisterHub({Key key, this.modify_hub}) : super(key: key);
  @override
  _RegisterHubState createState() => _RegisterHubState();
}

class _RegisterHubState extends State<RegisterHub> {
  final medicineHubIDController = TextEditingController();
  final medicineHubPortController = TextEditingController();
  final medicineHubHostController = TextEditingController();
  final medicineHubNameController = TextEditingController();
  Future<String> registerhub_Validate() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response hubresponse = await http.post(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'hub'),
        headers: {
          "Content-Type": "application/json",
          "authorization": usertoken
        },
        body: jsonEncode({
          'hubId': medicineHubIDController.text,
          'host': medicineHubHostController.text,
          'port': medicineHubPortController.text,
          'hubNm': medicineHubNameController.text
        }));
    if (hubresponse.statusCode == 201) {
      return "허브 등록 완료";
    } else if (hubresponse.statusCode == 409) {
      return "이미 존재하는 hub";
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
                height: size.height * 0.03,
              ),
              Center(
                child: Text(
                  "허브 등록",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
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
                  controller: medicineHubHostController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.device_hub,
                      color: Colors.black,
                    ),
                    hintText: "허브 ID 입력",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                height: size.height * 0.04,
                child: Text(
                  '허브 뒷편의 ID를 입력해 주세요',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontFamily: 'Noto',
                  ),
                ),
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
                  controller: medicineHubIDController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.device_hub,
                      color: Colors.black,
                    ),
                    hintText: "허브 Host 입력",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                height: size.height * 0.04,
                child: Text(
                  '허브 뒷편의 Host번호를 입력해 주세요',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontFamily: 'Noto',
                  ),
                ),
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
                  controller: medicineHubPortController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.device_hub,
                      color: Colors.black,
                    ),
                    hintText: "허브 PORT 입력",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                height: size.height * 0.04,
                child: Text(
                  '허브 뒷편의 PORT번호를 입력해 주세요',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontFamily: 'Noto',
                  ),
                ),
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
                  controller: medicineHubNameController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.device_hub,
                      color: Colors.black,
                    ),
                    hintText: "허브 닉네임 입력",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              RoundedButton(
                text: "허브 등록",
                press: () async {
                  String saveMessage = await registerhub_Validate();
                  if (saveMessage == "허브 등록 완료" && widget.modify_hub == 0) {
                    UserSecureStorage.setHubId(medicineHubIDController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => RegisterBottle(
                          hubid: medicineHubIDController.text,
                          modify_bottle: false,
                        ),
                      ),
                    );
                  } else if (saveMessage == "허브 등록 완료" &&
                      widget.modify_hub == 1) {
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
                              child: new Text('close'),
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
