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

class BottleWeight extends StatefulWidget {
  String bottleId;
  BottleWeight({Key key, this.bottleId}) : super(key: key);
  @override
  _BottleWeighteState createState() => _BottleWeighteState();
}

class _BottleWeighteState extends State<BottleWeight> {
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
          'bottleId': widget.bottleId,
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
    return MaterialApp(
      home: Scaffold(appBar: appbar(context), body: Text('df')),
    );
  }
}
