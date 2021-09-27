import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/user_secure_stoarge.dart';

import '../../models/Medicine.dart';

import '../Register/SearchMedicine.dart';
import '../../utils/flutter_material_pickers.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _seletedDoctor = '';
  Widget build(BuildContext context) {
    Medicine _medicineInformation = new Medicine();
    List<String> doctorlist = ['temp1', 'temp2', 'temp3', 'temp4'];

    Future<Medicine> _getmedicine() async {
      String usertoken = await UserSecureStorage.getUserToken();
      String medicineid = await UserSecureStorage.getMedicineId();

      http.Response medicineresponse = await http.get(
        Uri.encodeFull(
            DotEnv().env['SERVER_URL'] + 'medicine/' + medicineid.toString()),
        headers: {"authorization": usertoken},
      );

      if (medicineresponse.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(medicineresponse.body);
        _medicineInformation = Medicine.fromJson(data);
      }
      return _medicineInformation;
    }

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getmedicine(),
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
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(
                                25.0) //         <--- border radius here
                            ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            child: Center(
                              child: Text(
                                  '${snapshot.data.name}' == null
                                      ? '-'
                                      : '${snapshot.data.name}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: size.width,
                            alignment: Alignment(0.9, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '처방의: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  _medicineInformation.company == null
                                      ? '-'
                                      : _seletedDoctor,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: size.width,
                            alignment: Alignment(0.9, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '제조사: ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _medicineInformation.company == null
                                      ? '-'
                                      : _medicineInformation.company,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment(-1, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '타겟 층 : ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _medicineInformation.target == null
                                      ? '-'
                                      : _medicineInformation.target,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment(-1, 0),
                            child: Wrap(
                              children: [
                                Text(
                                  '복약 정보 : ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _medicineInformation.dosage == null
                                      ? '-'
                                      : _medicineInformation.dosage,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
                                    _medicineInformation.warn == null
                                        ? '-'
                                        : _medicineInformation.warn,
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
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.8,
                        height: 46,
                        margin: EdgeInsets.only(bottom: 0),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          onPressed: () async {
                            String bottleid =
                                await UserSecureStorage.getBottleId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchMedicine(
                                  bottleId: bottleid,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '약 검색',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.bold),
                          ),
                          color: Color(0xff1674f6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.8,
                        height: 46,
                        margin: EdgeInsets.only(bottom: 0),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          onPressed: () async {
                            await showMaterialScrollPicker(
                              context: context,
                              title: '처방의',
                              items: doctorlist,
                              selectedItem: _seletedDoctor,
                              onChanged: (value) => setState(() {
                                _seletedDoctor = value;
                              }),
                            );
                          },
                          child: Text(
                            '처방의 변경',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Noto',
                                fontWeight: FontWeight.bold),
                          ),
                          color: Color(0xff1674f6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
