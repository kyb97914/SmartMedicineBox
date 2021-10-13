import 'package:flutter/material.dart';

AppBar appbar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.blue.withOpacity(0.9),
    elevation: 0,
    leading: IconButton(
      icon: Icon(Icons.menu),
      onPressed: null,
    ),
    title: Text('Smart Medicine Box'),
  );
}
