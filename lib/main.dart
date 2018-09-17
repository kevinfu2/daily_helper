import 'package:daily_helper/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => (){
  debugPaintSizeEnabled=true;
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '一个测试',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

