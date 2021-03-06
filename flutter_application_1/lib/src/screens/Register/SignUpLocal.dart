import 'dart:convert';
import 'package:Smart_Medicine_Box/src/screens/Register/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/user_secure_stoarge.dart';
import 'package:Smart_Medicine_Box/src/screens/Loginpage.dart';
import 'RegsiterHub.dart';
import '../Components/background.dart';
import '../Components/RoundedButton.dart';
import 'Component/or_divider.dart';
import 'Component/social_icon.dart';
import '../Components/already_have_an_account_acheck.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk/all.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

final emailController = TextEditingController();
final passwordController = TextEditingController();
final passwordValidController = TextEditingController();
final userNameController = TextEditingController();
final contactController = TextEditingController();
final birthdateController = TextEditingController();

class SignUpLocal extends StatefulWidget {
  @override
  _SignUpLocalState createState() => _SignUpLocalState();
}

class _SignUpLocalState extends State<SignUpLocal> {
  bool _validate = false;
  bool _birthvalidate = false;
  bool _nextpage = false;
  // Initially password is obscure
  bool passwordVisible = false;
  bool passwordValidationVisible = false;
  String email;
  String password;
  String passwordValid;
  String userName;
  String contact;
  String birthdate;
  String accesstoken;

  var _socialSignupInfo = {
    "type": '',
    "accesstoken": '',
  };

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print(token.accessToken);
      var user = await UserApi.instance.me();
      print(user.kakaoAccount);

      _socialSignupInfo['accesstoken'] = token.accessToken;
      _socialSignupInfo['type'] = 'kakao';
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    _socialSignupInfo['type'] = 'google';
    _socialSignupInfo['accesstoken'] = googleAuth.idToken;
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _handleSignOut() async {
    googleSignIn.disconnect();
  }

  String tokenType;
  String token;

  Future<void> _naverLogin() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    NaverAccessToken tokens = await FlutterNaverLogin.currentAccessToken;
    print(token);
    _socialSignupInfo['type'] = 'naver';
    _socialSignupInfo['accesstoken'] = tokens.accessToken;
  }

  Future<String> signup_Validate() async {
    String devicetoken = await UserSecureStorage.getDeviceToken();
    http.Response response = await http.post(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'userId': email,
          'password': password,
          'passwordCheck': passwordValid,
          'userNm': userName,
          'birth': birthdate,
          'contact': contact,
          //'devicetoken': devicetoken
        },
      ),
    );
    if (response.statusCode == 201) {
      return "?????? ?????? ??????";
    } else {
      return "??????";
    }
  }

  Future<String> signup_Social() async {
    String devicetoken = await UserSecureStorage.getDeviceToken();

    http.Response response = await http.post(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] +
          'auth/register/social/' +
          _socialSignupInfo['type']),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          'accessToken': _socialSignupInfo['accesstoken'],
          'deviceToken': devicetoken
          //'devicetoken': devicetoken
        },
      ),
    );
    print(response.statusCode);
    print('asdg');
    if (response.statusCode == 201) {
      return "?????? ?????? ??????";
    } else {
      return "??????";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // int goals = 60;
    // int points = 75;
    return Scaffold(
      body: _nextpage == false
          ? GestureDetector(
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
                        "?????? ??????",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                        border: Border.all(),
                      ),
                      child: TextField(
                        onChanged: (text) {
                          email = text;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          hintText: "????????? ??????",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
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
                          hintText: "?????? ?????? ??????",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          hintText: "?????? ?????? ?????? ",
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
                              setState(() {
                                passwordValidationVisible =
                                    !passwordValidationVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    _validate
                        ? Text(
                            '??? ??????????????? ????????????. ?????? ??????????????????.',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    email != null && password != null && passwordValid != null
                        ? RoundedButton(
                            text: "Next",
                            press: () {
                              setState(() {
                                _nextpage = true;
                                //dialog?????? ??????
                              });
                            },
                          )
                        : RoundedButton(
                            text: "????????????",
                            press: () {
                              setState(() {});
                            },
                          ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignInPage()));
                      },
                    ),
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocalIcon(
                          iconSrc: "images/google-plus.svg",
                          press: () async {
                            await signInWithGoogle();
                            String savemessage = await signup_Social();
                            if (savemessage == "?????? ?????? ??????") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('????????????'),
                                    content: new Text('???????????? ??????'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
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
                        SizedBox(width: size.width * 0.05),
                        SocalIcon(
                          iconSrc: "images/naver.svg",
                          press: () async {
                            await _naverLogin();
                            String savemessage = await signup_Social();
                            if (savemessage == "?????? ?????? ??????") {
                              print('asdfg');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('????????????'),
                                    content: new Text('???????????? ??????'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
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
                        SizedBox(width: size.width * 0.05),
                        GestureDetector(
                          onTap: () async {
                            await _loginWithKakao();
                            String savemessage = await signup_Social();
                            if (savemessage == "?????? ?????? ??????") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('????????????'),
                                    content: new Text('???????????? ??????'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
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
                          child: Container(
                              height: 60,
                              width: 60,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset('images/kakao-talk.png')),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : GestureDetector(
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
                        "?????? ?????? ??????",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                        border: Border.all(),
                      ),
                      child: TextField(
                        onChanged: (text) {
                          userName = text;
                        },
                        controller: userNameController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintText: "??????",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      width: size.width * 0.8,
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
                          hintText: "????????? ??????",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 3),
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
                          hintText: "????????????(ex: 19980101)",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    birthdateController.text.length != 8
                        ? Text(
                            '8?????? ????????? ??????????????????(EX:19980101).',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    RoundedButton(
                      text: "????????????",
                      press: () async {
                        birthdate = birthdate.substring(0, 4) +
                            '-' +
                            birthdate.substring(4, 6) +
                            '-' +
                            birthdate.substring(6, 8);
                        String saveMessage = await signup_Validate();
                        if (saveMessage == "?????? ?????? ??????") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text('?????? ??????'),
                                  content: new Text('?????? ????????? ?????? ???????????????.'),
                                  actions: <Widget>[
                                    new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginPage()));
                                        })
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text('?????? ?????? ??????'),
                                  content: new Text('????????? ?????????, ??????????????? ????????? ?????????.'),
                                  actions: <Widget>[
                                    new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                );
                              });
                        }
                      },
                    ),
                    RoundedButton(
                      text: "??????",
                      press: () {
                        setState(() {
                          _nextpage = false;
                        });
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignInPage()));
                      },
                    ),
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocalIcon(
                          iconSrc: "images/google-plus.svg",
                          press: () async {
                            await signInWithGoogle();
                            String savemessage = await signup_Social();
                            if (savemessage == "?????? ?????? ??????") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('????????????'),
                                    content: new Text('???????????? ??????'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
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
                        SizedBox(width: size.width * 0.05),
                        SocalIcon(
                          iconSrc: "images/naver.svg",
                          press: () async {
                            await _naverLogin();
                            String savemessage = await signup_Social();
                            if (savemessage == "?????? ?????? ??????") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('????????????'),
                                    content: new Text('???????????? ??????'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
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
                        SizedBox(width: size.width * 0.05),
                        GestureDetector(
                          onTap: () async {
                            await _loginWithKakao();
                            String savemessage = await signup_Social();
                            if (savemessage == "?????? ?????? ??????") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('????????????'),
                                    content: new Text('???????????? ??????'),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text('Close'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage(),
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
                          child: Container(
                              height: 60,
                              width: 60,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset('images/kakao-talk.png')),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
