import 'package:flutter/material.dart';

class MyPage extends StatelessWidget{
  final String title;

  MyPage({this.title});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
       debugShowCheckedModeBanner: false,
        home: Scaffold(
           appBar: AppBar(
               title: Text('项目'),
           ),
           body:  Center(
              child: Text(
                title
              ),
           ),
        ),
      );
  }

}