import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/Medicine.dart';
import 'DetailMedicine.dart';
import '../../utils/user_secure_stoarge.dart';
import '../Components/background.dart';

class SearchMedicine extends StatefulWidget {
  String bottleId;
  SearchMedicine({Key key, this.bottleId}) : super(key: key);
  @override
  _SearchMedicineState createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  List<Medicine> _medicineList = new List<Medicine>();
  final medicineNameController = TextEditingController();

  Future<String> postMeicineList() async {
    String usertoken = await UserSecureStorage.getUserToken();
    print(Uri.encodeFull(DotEnv().env['SERVER_URL'] + 'medicine'));
    http.Response response = await http.get(
      Uri.encodeFull(DotEnv().env['SERVER_URL'] +
          'medicine?keyword=' +
          medicineNameController.text),
      headers: {"Content-Type": "application/json", "authorization": usertoken},
    );
    print(response.body);
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

  Future<void> dd() async {
    print("hello");
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
                            String saveMessage = await postMeicineList();
                            if (saveMessage == "GET") {
                              setState(() {});
                            }
                            //검색 함수를 여기다가
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DetailMedicine(
                                        searchMedicine: _medicineList[index],
                                        bottleId: widget.bottleId,
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
/*



 appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new Icon(Icons.medical_services_rounded,
            color: Colors.black, size: 45.0),
        title: Text(
          'Smart Medicine Box',
          style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'Noto',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: size.height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: size.height * 0.13,
              decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: size.height * 0.0635,
                        width: size.width * 0.75,
                        child: Row(
                          children: [
                            Container(
                              width: size.width * 0.16,
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text('약이름:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: size.width * 0.55,
                              child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: medicineNameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: '약 이름을 입력하세요',
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w600)),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                            right: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                        ),
                      ),
                      Container(
                        height: size.height * 0.0635,
                        width: size.width * 0.75,
                        child: Row(
                          children: [
                            Container(
                              width: size.width * 0.16,
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                              child: Text('제조사:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                              width: size.width * 0.50,
                              child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: medicineCompanyController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: '약 제조사 이름을 입력하세요',
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSansKR',
                                      fontWeight: FontWeight.w600)),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: size.height * 0.0635 * 2,
                    width: size.width * 0.14,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.search, size: 40),
                      onPressed: () async {
                        String saveMessage = await postMeicineList();
                        if (saveMessage == "GET") {
                          setState(() {});
                        }
                        //검색 함수를 여기다가
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(border: Border.all()),
                        child: ListTile(
                            title: Text(
                              'Medicine: ' + _medicineList[index].name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Noto',
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailMedicine(
                                      searchMedicine: _medicineList[index],
                                      bottleId: widget.bottleId,
                                    ),
                                  ));
                            }),
                      );
                    },
                    separatorBuilder: (BuildContext contetx, int index) =>
                        const Divider(),
                    itemCount: _medicineList.length == null
                        ? 0
                        : _medicineList.length))
          ],
        ),
      ),
    );
 */
