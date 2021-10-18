import 'package:flutter/material.dart';
import '../Main/SettingPage.dart';

AppBar appbar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.blue.withOpacity(0.9),
    elevation: 0,
    leading: Icon(
      Icons.medical_services_outlined,
      size: 35,
    ),
    title: Text('Smart Medicine Box'),
    actions: [
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SettingPage(),
                ));
          })
    ],
  );
}
