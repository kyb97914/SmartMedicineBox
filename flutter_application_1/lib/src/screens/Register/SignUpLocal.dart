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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential authResult = await _auth.signInWithCredential(credential);
    User user = authResult.user;
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
    print(response.statusCode);
    if (response.statusCode == 201) {
      return "정보 입력 완료";
    } else {
      return "오류";
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
    if (response.statusCode == 201) {
      return "정보 입력 완료";
    } else {
      return "오류";
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
                        "회원 가입",
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
                          hintText: "이메일 주소",
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
                            '두 비밀번호가 다릅니다. 다시 확인해주세요.',
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
                                //dialog뿌려 주기
                              });
                            },
                          )
                        : RoundedButton(
                            text: "회원가입",
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
                            await signup_Social();
                          },
                        ),
                        SizedBox(width: size.width * 0.05),
                        SocalIcon(
                          iconSrc: "images/naver.svg",
                          press: () async {
                            await _naverLogin();
                            await signup_Social();
                          },
                        ),
                        SizedBox(width: size.width * 0.05),
                        SocalIcon(
                          iconSrc: "images/google-plus.svg",
                          press: () {},
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
                        "추가 정보 입력",
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
                          hintText: "이름",
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
                          hintText: "핸드폰 번호",
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
                    RoundedButton(
                      text: "회원가입",
                      press: () async {
                        birthdate = birthdate.substring(0, 4) +
                            '-' +
                            birthdate.substring(4, 6) +
                            '-' +
                            birthdate.substring(6, 8);
                        String saveMessage = await signup_Validate();
                        if (saveMessage == "정보 입력 완료") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: new Text('회원 가입'),
                                  content: new Text('회원 가입이 완료 되었습니다.'),
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
                                  title: new Text('회원 가입 오류'),
                                  content: new Text('정확한 이메일, 비밀번호를 입력해 주세요.'),
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
                      text: "이전",
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
                            await signup_Social();
                          },
                        ),
                        SizedBox(width: size.width * 0.05),
                        SocalIcon(
                          iconSrc: "images/naver.svg",
                          press: () async {
                            await _naverLogin();
                            await signup_Social();
                          },
                        ),
                        SizedBox(width: size.width * 0.05),
                        SocalIcon(
                          iconSrc: "images/google-plus.svg",
                          press: () {},
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
/*
 
          Container(
            height: 80,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: RaisedButton(
              onPressed: () async {
                String saveMessage = await signup_Validate();
                if (saveMessage == "정보 입력 완료") {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('회원 가입'),
                          content: new Text('회원 가입이 완료 되었습니다.'),
                          actions: <Widget>[
                            new FlatButton(
                                child: new Text('Close'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
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
                          title: new Text('회원 가입 오류'),
                          content: new Text('정확한 이메일, 비밀번호를 입력해 주세요.'),
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
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)),
              color: Color(0xff1674f6),
              child: Text(
                '회원 가입',
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                child: Text(
                  '회원 가입시, 이용 약관 및 개인정보 처리 방침에 동의하는 것으로 간주합니다..',
                  style: TextStyle(fontSize: 12, color: Color(0xff747474)),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );


 */
