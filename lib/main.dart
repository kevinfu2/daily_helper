import 'package:daily_helper/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  debugPaintSizeEnabled=true;
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '手机助手',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

