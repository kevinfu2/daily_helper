import 'package:daily_helper/my_navigator.dart';
import 'package:daily_helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  //debugPaintSizeEnabled=true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _checkPersmission();
    return MaterialApp(
      title: 'daily helper',
      debugShowCheckedModeBanner: false,
      theme: kLightGalleryTheme.data,
      home: new MyHomePage(),
    );
  }

  void _checkPersmission() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    if (!hasPermission) {
      await SimplePermissions.requestPermission(Permission.WhenInUseLocation);
    }
  }
}
