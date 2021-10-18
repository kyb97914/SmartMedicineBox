import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Medicine.dart';
import 'DetailMedicine.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/background.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import '../../models/Doctor.dart';
import '../../screens/Main/DashBoard.dart';

class SearchMedicine extends StatefulWidget {
  String bottleId;
  SearchMedicine({Key key, this.bottleId}) : super(key: key);
  @override
  _SearchMedicineState createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  List<Medicine> _medicineList = new List<Medicine>();
  final medicineNameController = TextEditingController();
  String medicineId, doctorId, dailyDosage, totalDosage;
  List<Doctor> _doctorlist = new List<Doctor>();

  Future<String> patchMedcine() async {
    String usertoken = await UserSecureStorage.getUserToken();

    http.Response response = await http.patch(
        Uri.encodeFull(
            DotEnv().env['SERVER_URL'] + 'bottle/' + widget.bottleId),
        headers: {
          "Content-Type": "application/json",
          "authorization": usertoken
        },
        body: jsonEncode({
          'medicineId': medicineId,
          'dailyDosage': dailyDosage,
          'totalDosage': totalDosage,
          'doctorId': doctorId
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

  Future<String> getDoctorList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'user/doctor'),
      headers: {"authorization": usertoken},
    );
    if (_doctorlist.length != 0) {
      _doctorlist.clear();
    }
    Doctor temp = new Doctor(doctorNm: "담당의 없음", doctorId: "담당의 없음");
    _doctorlist.add(temp);
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> values = new List<dynamic>();
      Map<String, dynamic> map = json.decode(response.body);
      values = map["doctorList"];
      for (int i = 0; i < values.length; i++) {
        Map<String, dynamic> map = values[i];
        _doctorlist.add(Doctor.fromJson(map));
      }

      return "GET";
    } else if (response.statusCode == 404) {
      return "Not Found";
    } else {
      return "Error";
    }
  }

  Future<bool> checkPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();
    bool per = true;

    statuses.forEach((permission, permissionStatus) {
      if (!permissionStatus.isGranted) {
        per = false;
      }
    });
    return per;
  }

  String qrCode;

  Future<String> postMeicineList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] +
          'medicine?keyword=' +
          medicineNameController.text),
      headers: {"Content-Type": "application/json", "authorization": usertoken},
    );
    if (_medicineList.length != 0) {
      _medicineList.clear();
    }
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      Map<String, dynamic> map = json.decode(response.body);
      values = map["medicineList"];
      for (int i = 0; i < values.length; i++) {
        Map<String, dynamic> map = values[i];
        _medicineList.add(Medicine.fromJson(map));
      }
      return "GET";
    } else {
      return "Not Found";
    }
  }

  Future<void> scan() async {
    String temp = await scanner.scan();
    setState(() {
      medicineId = temp.split('/')[0];
      dailyDosage = temp.split('/')[1];
      totalDosage = temp.split('/')[2];
      doctorId = temp.split('/')[3];
      qrCode = temp;
    });
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Background(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Center(
                  child: Text(
                    "약 검색",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.7,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700.withOpacity(0.1),
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) async {
                            await postMeicineList();
                            setState(() {});
                          },
                          controller: medicineNameController,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '약 검색',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Center(
                      child: Container(
                        width: size.width * 0.15,
                        height: size.height * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner,
                            size: size.height * 0.05,
                          ),
                          onPressed: () async {
                            await checkPermission();
                            await scan();
                            String saveMessage = await patchMedcine();
                            //검색 함수를 여기다가
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
                                                builder:
                                                    (BuildContext context) =>
                                                        DashBoard(
                                                  pageNumber: 1,
                                                ),
                                              ),
                                            );
                                          })
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text('약 등록'),
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 90,
                          padding: EdgeInsets.only(
                              left: 30, bottom: 10, top: 10, right: 5),
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
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _medicineList[index].name + "\n",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: _medicineList[index].company,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  String savemessage = await getDoctorList();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DetailMedicine(
                                        searchMedicine: _medicineList[index],
                                        bottleId: widget.bottleId,
                                        doctorlist: _doctorlist,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext contetx, int index) =>
                          const Divider(),
                      itemCount: _medicineList.length == null
                          ? 0
                          : _medicineList.length),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
