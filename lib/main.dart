import 'package:daily_helper/my_navigator.dart';
import 'package:daily_helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled=true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0175c2);
    return MaterialApp(
      title: 'daily helper',
      debugShowCheckedModeBanner: false,
      theme: kLightGalleryTheme.data,
      home: new MyHomePage(),
    );
  }
}
