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
               title: Text('hessds'),
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