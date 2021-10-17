import 'package:flutter/material.dart';
import '../../utils/user_secure_stoarge.dart';

import '../../models/Medicine.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Doctor.dart';
import '../../models/Feedback.dart';
import '../../models/Bottleinfo.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  Widget build(BuildContext context) {
    List<DoctorFeedback> _feedbacklist = new List<DoctorFeedback>();
    final Size size = MediaQuery.of(context).size;
    BottleInfo _bottleinfo;
    String _bottleId;
    //feedback get요청
    Future<String> getFeedBackList() async {
      String usertoken = await UserSecureStorage.getUserToken();
      String bottleId = await UserSecureStorage.getBottleId();
      http.Response response = await http.get(
        Uri.encodeFull(
            DotEnv().env['SERVER_URL'] + 'bottle/feedback/' + bottleId),
        headers: {"authorization": usertoken},
      );

      if (response.statusCode == 200) {
        List<dynamic> values = new List<dynamic>();
        Map<String, dynamic> map = json.decode(response.body);
        values = map["feedbackList"];
        for (int i = 0; i < values.length; i++) {
          Map<String, dynamic> map = values[i];
          _feedbacklist.add(DoctorFeedback.fromJson(map));
        }
        return "get완료";
      } else if (response.statusCode == 404) {
        return "Not Found";
      } else {
        return "Error";
      }
    }

    //get bottle info
    Future<String> getbottlemedicine() async {
      String usertoken = await UserSecureStorage.getUserToken();
      String bottleid = await UserSecureStorage.getBottleId();
      _bottleId = bottleid;
      http.Response response = await http.get(
        Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/' + bottleid),
        headers: {"authorization": usertoken},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        _bottleinfo = BottleInfo.fromJson(map);
        return "get";
      } else {
        return "error";
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getFeedBackList(),
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
                height: size.height * 0.9,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.15,
                      width: size.width * 0.9,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: FutureBuilder(
                        future: getbottlemedicine(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                                        text: '처방의 : ' +
                                            _bottleinfo.doctorInfo.doctorNm +
                                            "\n",
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
                                        text: _bottleinfo.doctorInfo.contact +
                                            "\n",
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
                                        text: _bottleinfo.doctorInfo.hospitalNm,
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
                    SizedBox(height: 10),
                    Container(
                      width: 303,
                      height: 70,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: 75,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                  child: Text(
                                    '권고',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Noto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: 75,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                  child: Text(
                                    '주의',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Noto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: 75,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                  child: Text(
                                    '경고',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Noto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            width: 75,
                            child: Column(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Container(
                                  child: Text(
                                    '치명',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Noto',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            color: Colors.grey.withOpacity(0.05)),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: _feedbacklist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        title: new Text('피드백 내용'),
                                        content: Container(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '처방의:\n' +
                                                      _bottleinfo
                                                          .doctorInfo.doctorNm +
                                                      "\n",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: "  \n",
                                                  style: TextStyle(
                                                    fontSize: 3,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '피드백 내용 :\n' +
                                                      _feedbacklist[index]
                                                          .feedback +
                                                      "\n",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: '시간 :\n' +
                                                      _feedbacklist[index]
                                                          .fdbDtm
                                                          .toString()
                                                          .substring(0, 16) +
                                                      "\n",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                              child: new Text('닫기'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              })
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                height: 80,
                                padding: EdgeInsets.only(
                                    left: 30, bottom: 10, top: 10, right: 30),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 10),
                                      blurRadius: 2,
                                      color: Color(0xFFD3D3D3).withOpacity(0.3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: <Widget>[
                                    RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                _feedbacklist[index].feedback +
                                                    "\n",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: " \n",
                                            style: TextStyle(
                                                fontSize: 5,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: _feedbacklist[index]
                                                .fdbDtm
                                                .toString()
                                                .substring(0, 16),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.circle,
                                      color: _feedbacklist[index].fdbType ==
                                              "CRITICAL"
                                          ? Colors.black
                                          : (_feedbacklist[index].fdbType ==
                                                  "WARN"
                                              ? Colors.red
                                              : (_feedbacklist[index].fdbType ==
                                                      "CAUTION"
                                                  ? Colors.orange
                                                  : Colors.blue)),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext contetx, int index) =>
                              const Divider(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
