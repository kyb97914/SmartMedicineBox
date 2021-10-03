import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/user_secure_stoarge.dart';
import 'HubList.dart';
import '../../models/User.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

var _socialLoginInfo = {
  "email": '',
  "type": '',
  "accesstoken": '',
};

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  UserCredential authResult = await _auth.signInWithCredential(credential);
  User user = authResult.user;
  print('AccessToken: ' + googleAuth.accessToken);
  print('IDTOKEN: ' + googleAuth.idToken);
  print('email: ' + user.email);
  _socialLoginInfo['email'] = user.email;
  _socialLoginInfo['accessToken'] = googleAuth.accessToken;
  _socialLoginInfo['type'] = 'google';
  print(googleSignIn.currentUser);
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> _handleSignOut() async {
  googleSignIn.disconnect();
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

///
class _SignInPageState extends State<SignInPage> {
  bool passwordVisible = false;
  bool _validateEmail = false;
  bool _validatePassword = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LocalUser user;
  List<int> _hublist = new List<int>(); //허브이름을 만들어야 할 것 같은데 임시로 허브 id만 고르게 함

  //Login 함수

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final mqData = MediaQuery.of(context);
    final mqDataScale = mqData.copyWith(textScaleFactor: 1.0);

    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          //Navigator.pop(context);
          Navigator.of(context).pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 18, right: 18),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text('로그인',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 34,
                                    fontFamily: 'Noto',
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: new Column(
                              children: <Widget>[
                                MediaQuery(
                                  data: mqDataScale,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: '이메일',
                                      helperText: '이메일 주소를 입력해주세요.',
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      errorText: _validateEmail
                                          ? '등록되지 않은 아이디입니다.'
                                          : null,
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000)),
                                      helperStyle: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffb2b2b2)),
                                      // Here is key idea
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: new Column(
                              children: <Widget>[
                                MediaQuery(
                                  data: mqDataScale,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: passwordController,
                                    obscureText:
                                        !passwordVisible, //This will obscure text dynamically
                                    decoration: InputDecoration(
                                      labelText: '비밀번호',
                                      helperText: '비밀번호를 입력해 주세요.',
                                      errorText: _validatePassword
                                          ? '비밀번호가 일치하지 않습니다.'
                                          : null,
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000)),
                                      helperStyle: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffb2b2b2)),
                                      // Here is key idea
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Color(0xff2c2c2c),
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
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: size.width * 0.8,
                                height: size.height * 0.07,
                                child: RaisedButton(
                                  color: Color(0xff1674f6),
                                  child: Text("로그인",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Noto',
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    String saveMessage = await login(
                                        emailController.text,
                                        passwordController.text,
                                        user);
                                    if (emailController.text.isEmpty ||
                                        passwordController.text.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: new Text('이메일 & 비밀번호'),
                                              content: new Text(
                                                  '이메일과 비밀번호를 입력해주세요.'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                    child: new Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                              ],
                                            );
                                          });
                                    } else {
                                      if (saveMessage == "로그인 성공") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HubList(hublist: _hublist),
                                          ),
                                        );
                                      } else {
                                        print('Error');
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              Container(
                                width: size.width * 0.8,
                                height: size.height * 0.07,
                                child: RaisedButton(
                                  color: Color(0xff1674f6),
                                  child: Text("구글 로그인",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Noto',
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    signInWithGoogle();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              Container(
                                width: size.width * 0.8,
                                height: size.height * 0.07,
                                child: RaisedButton(
                                  color: Color(0xff1674f6),
                                  child: Text("구글 로그dkdnt",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Noto',
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    _handleSignOut();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<String> login(String _email, String _password, LocalUser user) async {
  http.Response response = await http.post(
    Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'auth/login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(
      {
        'userId': _email,
        'password': _password,
      },
    ),
  );
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    user = LocalUser.fromJson(data);
    UserSecureStorage.setUserToken(user.token);
    UserSecureStorage.setUserId(user.userId);
    return "로그인 성공";
  } else if (response.statusCode == 400) {
    return "올바르지 않은 아이디 및 패스워드";
  } else {
    return "존재하지 않는 아이디 이거나 비밀번호가 불일치 합니다.";
  }
}
