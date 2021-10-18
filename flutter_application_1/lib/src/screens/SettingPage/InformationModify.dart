import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Smart_Medicine_Box/src/screens/Components/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Smart_Medicine_Box/src/utils/user_secure_stoarge.dart';
import 'package:Smart_Medicine_Box/src/models/UserProfile.dart';
import 'package:Smart_Medicine_Box/src/screens/Components/RoundedButton.dart';

class InformationModify extends StatefulWidget {
  @override
  _InformationModifyState createState() => _InformationModifyState();
}

class _InformationModifyState extends State<InformationModify> {
  final birthdateController = TextEditingController();
  final contactController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordValidController = TextEditingController();
  bool _validate = false;
  int userRole = 0;
  String _userLoginType;

  // Initially password is obscure
  bool passwordVisible = false;
  bool passwordValidationVisible = false;
  bool _birthvalidate = false;
  UserProfile userprofile;
  String contact;
  String birthdate;
  String password;
  String passwordValid;

  Future<String> getInfo() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'user'),
      headers: {"authorization": usertoken},
    );
    Map<String, dynamic> map = json.decode(response.body);
    userprofile = UserProfile.fromJson(map['profile']);
    _userLoginType = await UserSecureStorage.getUserType();
    return "Get 완료";
  }

  Future<String> patchMedcine() async {
    String usertoken = await UserSecureStorage.getUserToken();

    http.Response response = await http.patch(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'user'),
        headers: {
          "Content-Type": "application/json",
          "authorization": usertoken
        },
        body: jsonEncode({
          'birth': birthdateController.text,
          'contact': contactController.text,
          'password': passwordController.text,
          'passwordCheck': passwordValidController.text
        }));
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
    return Scaffold(
      appBar: appbar(context),
      body: FutureBuilder(
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
            if (_userLoginType == 'Social') {
              //비번 변경 x
              //생년 월일와 연락처만 수정 가능
              return ListView(
                padding: const EdgeInsets.all(30),
                children: <Widget>[
                  Center(
                    child: Text(
                      "유저 정보 변경",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    height: size.height * 0.15,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Row(
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
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.person),
                        SizedBox(width: 20),
                        Text(
                          userprofile.userNm,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    width: size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(),
                    ),
                    child: TextField(
                      controller: contactController,
                      onChanged: (text) {
                        contact = text;
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        hintText: "핸드폰 번호",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(),
                    ),
                    child: TextField(
                      controller: birthdateController,
                      onChanged: (text) {
                        birthdate = text;
                        if (birthdate.length != 8) {
                          _birthvalidate = true;
                        }
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        hintText: "생년월일(ex: 19980101)",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  birthdateController.text.length != 8
                      ? Text(
                          '8자리 숫자로 입력해주세요(EX:19980101).',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  SizedBox(height: size.height * 0.03),
                  RoundedButton(
                    text: "정보 수정",
                    press: () async {
                      String message = await patchMedcine();
                      if (message == "Complete") {
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text('정보 수정 오류'),
                              content: new Text('오류 발생'),
                              actions: <Widget>[
                                new FlatButton(
                                    child: new Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return ListView(
                padding: const EdgeInsets.all(30),
                children: <Widget>[
                  Center(
                    child: Text(
                      "유저 정보 변경",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    height: 90,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: Row(
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
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(),
                    ),
                    child: TextField(
                      controller: passwordController,
                      onChanged: (text) {
                        password = text;
                      },
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: "비밀 번호 입력",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
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
                      controller: passwordValidController,
                      onChanged: (text) {
                        passwordValid = text;
                        if (password == text) {
                          setState(() {
                            _validate = false;
                          });
                        } else {
                          setState(() {
                            _validate = true;
                          });
                        }
                      },
                      obscureText: !passwordValidationVisible,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: "비밀 번호 확인 ",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordValidationVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(
                              () {
                                passwordValidationVisible =
                                    !passwordValidationVisible;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  _validate
                      ? Text(
                          '두 비밀번호가 다릅니다. 다시 확인해주세요.',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    width: size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(),
                    ),
                    child: TextField(
                      controller: contactController,
                      onChanged: (text) {
                        contact = text;
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        hintText: "핸드폰 번호",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                      border: Border.all(),
                    ),
                    child: TextField(
                      controller: birthdateController,
                      onChanged: (text) {
                        birthdate = text;
                        if (birthdate.length != 8) {
                          _birthvalidate = true;
                        }
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        hintText: "생년월일(ex: 19980101)",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  birthdateController.text.length != 8
                      ? Text(
                          '8자리 숫자로 입력해주세요(EX:19980101).',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'Noto',
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  SizedBox(height: size.height * 0.01),
                  RoundedButton(
                    text: "정보 수정",
                    press: () async {
                      String message = await patchMedcine();
                      if (message == "Complete") {
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text('정보 수정 오류'),
                              content: new Text('오류 발생'),
                              actions: <Widget>[
                                new FlatButton(
                                    child: new Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
