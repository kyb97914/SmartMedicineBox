import 'package:Smart_Medicine_Box/src/screens/Main/DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Medicine.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/appbar.dart';
import '../Components/RoundedButton.dart';
import '../../models/Doctor.dart';

class DetailMedicine extends StatefulWidget {
  Medicine searchMedicine;
  String bottleId;
  List<Doctor> doctorlist;
  DetailMedicine({Key key, this.searchMedicine, this.bottleId, this.doctorlist})
      : super(key: key);
  @override
  _DetailMedicineState createState() => _DetailMedicineState();
}

class _DetailMedicineState extends State<DetailMedicine> {
  final medicinedailyDosageController = TextEditingController();
  final medicinetotalDosageController = TextEditingController();
  String _chosenValue = "담당의 없음";
  //약 등록
  Future<String> patchMedcine() async {
    String usertoken = await UserSecureStorage.getUserToken();
    String doctorid;
    if (_chosenValue == "담당의 없음") {
      doctorid = null;
    } else {
      for (int i = 0; i < widget.doctorlist.length; i++) {}
    }
    http.Response response = await http.patch(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'bottle/' + widget.bottleId),
      headers: {"Content-Type": "application/json", "authorization": usertoken},
      body: jsonEncode(
        {
          'medicineId': widget.searchMedicine.medicineId,
          'dailyDosage': medicinedailyDosageController.text,
          'totalDosage': medicinetotalDosageController.text
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

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: appbar(context),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                width: size.width,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(
                      Radius.circular(25.0) //         <--- border radius here
                      ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      child: Center(
                        child: Text(widget.searchMedicine.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: size.width,
                      alignment: Alignment(0.9, 0),
                      child: Text(
                        '제조사: ' + widget.searchMedicine.company,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      alignment: Alignment(-1, 0),
                      child: Text(
                        '타겟 층 : ' + widget.searchMedicine.target,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      alignment: Alignment(-1, 0),
                      child: Text(
                        '복약 정보 : ' + widget.searchMedicine.dosage,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      alignment: Alignment(-1, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: size.width,
                            child: Text(
                              '경고',
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: size.width,
                            child: Text(
                              widget.searchMedicine.warn,
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
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
                  controller: medicinedailyDosageController,
                  decoration: InputDecoration(
                    hintText: "하루에 섭취할 적정 복용량을 숫자만 입력하세요",
                    border: InputBorder.none,
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
                  controller: medicinetotalDosageController,
                  decoration: InputDecoration(
                    hintText: "총 약의 갯수를 입력하세요",
                    border: InputBorder.none,
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
                child: DropdownButton(
                  isExpanded: true,
                  focusColor: Colors.white,
                  iconEnabledColor: Colors.black,
                  value: _chosenValue,
                  items: widget.doctorlist.map(
                    (value) {
                      return DropdownMenuItem(
                          value: value.doctorNm, child: Text(value.doctorNm));
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
              ),
              RoundedButton(
                text: "약 등록",
                color: Colors.blue,
                textColor: Colors.white,
                press: () async {
                  String saveMessage = await patchMedcine();
                  if (saveMessage == "Complete") {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text('약 등록'),
                            content: new Text('약 등록이 완료 되었습니다.'),
                            actions: <Widget>[
                              new FlatButton(
                                  child: new Text('Close'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            DashBoard(
                                          pageNumber: 1,
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          );
                        });
                  }
                },
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
